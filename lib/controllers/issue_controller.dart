import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/issue.dart';
import 'navigation_controller.dart';
import 'reward_controller.dart';
import 'user_controller.dart';
import '../main_layout.dart';
import '../utils/global_constants.dart';
import '../api/api_service.dart';
import '../api/ai_analysis_service.dart';

class IssueController extends GetxController {
  var issues = <Issue>[].obs;
  var isLoading = true.obs;
  var selectedStatus = 'all'.obs;
  var showActiveIssues = false.obs;
  var isAnalyzingImage = false.obs;
  final AiAnalysisService _aiService = Get.find<AiAnalysisService>();

  List<Issue> get filteredIssues {
    if (selectedStatus.value == 'all') return issues;
    return issues.where((issue) => issue.status.name == selectedStatus.value).toList();
  }
  @override
  void onInit() { super.onInit(); loadIssues(); }

  Future<void> loadIssues() async {
    isLoading.value = true;
    try {
      final token = await Get.find<ApiService>().getToken();
      if (token == null) {
        // Clear issues if not logged in
        issues.clear();
        isLoading.value = false;
        return;
      }

      final filter = showActiveIssues.value ? 'active' : 'all';
      final response = await http.get(
        Uri.parse('$API_BASE_URL/issues?filter=$filter'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        issues.value = data.map((json) => Issue.fromJson(json)).toList();
      } else {
        // Clear issues on API error
        issues.clear();
      }
    } catch (e) {
      // Clear issues on network or other errors
      issues.clear();
    }
    isLoading.value = false;
  }

  void filterByStatus(String status) { selectedStatus.value = status; }

  void toggleActiveIssues() {
    showActiveIssues.value = !showActiveIssues.value;
    loadIssues();
  }

  Future<void> submitIssueToAPI({
    required String title,
    required String description,
    required String location,
    required String submittedBy,
    XFile? imageFile,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final token = await Get.find<ApiService>().getToken();
      if (token == null) {
        Get.snackbar('Error', 'Please login to submit issues');
        return;
      }

      // Step 1: Analyze image with AI model if image is provided
      AiAnalysisResult? aiAnalysis;
      if (imageFile != null) {
        isAnalyzingImage.value = true;
        try {
          aiAnalysis = await _aiService.analyzeImage(imageFile);
          if (aiAnalysis != null) {
            print('AI Analysis completed: ${aiAnalysis.summary}');
          } else {
            print('AI Analysis failed, proceeding without analysis');
          }
        } catch (e) {
          print('Error during AI analysis: $e');
          // Continue without AI analysis
        } finally {
          isAnalyzingImage.value = false;
        }
      }

      // Step 2: Submit issue to main API with AI analysis results
      var request = http.MultipartRequest('POST', Uri.parse('$API_BASE_URL/issues'));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['location'] = location;
      request.fields['submittedBy'] = submittedBy;

      if (latitude != null && longitude != null) {
        request.fields['latitude'] = latitude.toString();
        request.fields['longitude'] = longitude.toString();
      }

      // Add AI analysis results to the request
      if (aiAnalysis != null) {
        request.fields['aiAnalysis'] = jsonEncode(aiAnalysis.toJson());
        // Use the annotated image from AI analysis if available
        if (aiAnalysis.annotatedImageUrl.isNotEmpty) {
          request.fields['annotatedImageUrl'] = aiAnalysis.annotatedImageUrl;
        }
      }

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('issueImage', imageFile.path));
      }

      final response = await request.send();
      if (response.statusCode == 201) {
        String successMessage = 'Issue submitted successfully!';
        if (aiAnalysis != null && aiAnalysis.detections.isNotEmpty) {
          successMessage += '\nAI detected: ${aiAnalysis.summary}';
        }
        Get.snackbar('Success', successMessage);
        await loadIssues();
        Get.find<NavigationController>().setIndex(0);
        Get.offAll(() => MainLayout());
      } else {
        Get.snackbar('Error', 'Failed to submit issue');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: ${e.toString()}');
    }
  }

  void redeemPointsForIssue(Issue issue) {
    final issueIndex = issues.indexWhere((i) => i.id == issue.id);
    if (issueIndex != -1 && !issues[issueIndex].pointsRedeemed) {
      issues[issueIndex].pointsRedeemed = true;
      Get.find<RewardController>().addTransaction('Redeemed for ${issue.id}', 50);
      saveIssues(); // This line will now work correctly
      issues.refresh();
      Get.snackbar('redeemSuccess'.tr, '', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('pointsRedeemed'.tr, '', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  Future<void> saveIssues() async {
    final prefs = await SharedPreferences.getInstance();
    final issuesJson = issues.map((i) => jsonEncode(i.toJson())).toList();
    await prefs.setStringList('issues', issuesJson);
  }
}