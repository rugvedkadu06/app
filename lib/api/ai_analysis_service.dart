// lib/api/ai_analysis_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utils/global_constants.dart';

class AiAnalysisService extends GetxService {
  
  /// Sends image to AI model for analysis and returns detection results
  Future<AiAnalysisResult?> analyzeImage(XFile imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$AI_MODEL_BASE_URL/analyze'));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      
      final response = await request.send();
      
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        
        return AiAnalysisResult.fromJson(jsonData);
      } else {
        print('AI Analysis failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during AI analysis: $e');
      return null;
    }
  }
}

class Detection {
  final String className;
  final double confidence;
  final List<int> bbox; // [x1, y1, x2, y2]
  final String severity;
  final String priority;

  Detection({
    required this.className,
    required this.confidence,
    required this.bbox,
    required this.severity,
    required this.priority,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      className: json['class'],
      confidence: json['confidence'].toDouble(),
      bbox: List<int>.from(json['bbox']),
      severity: json['severity'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class': className,
      'confidence': confidence,
      'bbox': bbox,
      'severity': severity,
      'priority': priority,
    };
  }
}

class AiAnalysisResult {
  final String id;
  final String annotatedImageUrl;
  final List<Detection> detections;
  final DateTime createdAt;

  AiAnalysisResult({
    required this.id,
    required this.annotatedImageUrl,
    required this.detections,
    required this.createdAt,
  });

  factory AiAnalysisResult.fromJson(Map<String, dynamic> json) {
    return AiAnalysisResult(
      id: json['_id'],
      annotatedImageUrl: json['annotatedImageUrl'],
      detections: (json['detections'] as List)
          .map((detection) => Detection.fromJson(detection))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'annotatedImageUrl': annotatedImageUrl,
      'detections': detections.map((d) => d.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Get the highest severity level from all detections
  String get highestSeverity {
    if (detections.isEmpty) return 'Unknown';
    
    final severities = detections.map((d) => d.severity).toList();
    if (severities.contains('High')) return 'High';
    if (severities.contains('Medium')) return 'Medium';
    if (severities.contains('Low')) return 'Low';
    return 'Unknown';
  }

  /// Get the highest priority level from all detections
  String get highestPriority {
    if (detections.isEmpty) return 'Low';
    
    final priorities = detections.map((d) => d.priority).toList();
    if (priorities.contains('Urgent')) return 'Urgent';
    if (priorities.contains('Normal')) return 'Normal';
    if (priorities.contains('Low')) return 'Low';
    return 'Low';
  }

  /// Get summary of detected issues
  String get summary {
    if (detections.isEmpty) return 'No issues detected';
    
    final classCounts = <String, int>{};
    for (final detection in detections) {
      classCounts[detection.className] = (classCounts[detection.className] ?? 0) + 1;
    }
    
    final summaryParts = <String>[];
    classCounts.forEach((className, count) {
      summaryParts.add('$count ${className.toLowerCase()}');
    });
    
    return summaryParts.join(', ');
  }
}
