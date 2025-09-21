// lib/screens/issues/issue_detail_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/issue.dart';
import '../../controllers/issue_controller.dart';
import '../../widgets/info_chip.dart';
import '../../widgets/status_tracker.dart';
import '../../widgets/google_map_widget.dart';
import '../../api/ai_analysis_service.dart';

class IssueDetailPage extends StatelessWidget {
  final Issue issue;
  const IssueDetailPage({super.key, required this.issue});

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: issue.imageUrl != null && issue.imageUrl!.isNotEmpty
                    ? Image.network(issue.imageUrl!, fit: BoxFit.contain)
                    : issue.imagePath != null && issue.imagePath!.isNotEmpty
                    ? Image.file(File(issue.imagePath!), fit: BoxFit.contain)
                    : Image.network(issue.placeholderImageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullMap(BuildContext context) {
    if (issue.coordinates == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMapWidget(
                  latitude: issue.coordinates!['latitude']!,
                  longitude: issue.coordinates!['longitude']!,
                  title: issue.title,
                  description: issue.location,
                  height: MediaQuery.of(context).size.height * 0.8,
                  isInteractive: true,
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      issue.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.blue.shade600, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Lat: ${issue.coordinates!['latitude']!.toStringAsFixed(6)}, Lng: ${issue.coordinates!['longitude']!.toStringAsFixed(6)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final issueCtrl = Get.find<IssueController>();
    final currentStatusIndex = IssueStatus.values.indexOf(issue.status);
    return Scaffold(
      appBar: AppBar(title: Text('issueDetails'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showFullImage(context),
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      issue.imageUrl != null && issue.imageUrl!.isNotEmpty
                          ? Image.network(issue.imageUrl!, fit: BoxFit.cover)
                          : issue.imagePath != null && issue.imagePath!.isNotEmpty
                          ? Image.file(File(issue.imagePath!), fit: BoxFit.cover)
                          : Image.network(issue.placeholderImageUrl, fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.zoom_in, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(issue.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InfoChip(icon: Icons.person_outline, text: 'Submitted by: ${issue.submittedBy}'),
            InfoChip(icon: Icons.calendar_today_outlined, text: DateFormat.yMMMMd().format(issue.createdAt)),
            InfoChip(icon: Icons.location_on_outlined, text: issue.location),
            if (issue.coordinates != null) ...[
              const SizedBox(height: 16),
              Text('Location on Map', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showFullMap(context),
                child: GoogleMapWidget(
                  latitude: issue.coordinates!['latitude']!,
                  longitude: issue.coordinates!['longitude']!,
                  title: issue.title,
                  description: issue.location,
                  height: 200,
                  isInteractive: false,
                  onTap: (LatLng position) => _showFullMap(context),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(issue.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
            if (issue.aiAnalysis != null && issue.aiAnalysis!.detections.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildAiAnalysisSection(context),
            ],
            const SizedBox(height: 24),
            Text('statusTracker'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            StatusTracker(currentIndex: currentStatusIndex),
            const SizedBox(height: 32),
            if (issue.status == IssueStatus.resolved)
              Obx(() {
                final latestIssue = issueCtrl.issues.firstWhere((i) => i.id == issue.id, orElse: () => issue);
                return SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: latestIssue.pointsRedeemed ? null : () => issueCtrl.redeemPointsForIssue(issue), icon: const Icon(Icons.star), label: Text(latestIssue.pointsRedeemed ? 'pointsRedeemed'.tr : 'redeemPoints'.tr), style: ElevatedButton.styleFrom(backgroundColor: latestIssue.pointsRedeemed ? Colors.grey : Colors.green)));
              })
          ],
        ),
      ),
    );
  }

  Widget _buildAiAnalysisSection(BuildContext context) {
    final analysis = issue.aiAnalysis!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'AI Analysis Results',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnalysisSummary(context, analysis),
            const SizedBox(height: 16),
            ...analysis.detections.map((detection) => _buildDetectionCard(context, detection)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSummary(BuildContext context, AiAnalysisResult analysis) {
    final severity = analysis.highestSeverity;
    final priority = analysis.highestPriority;

    Color severityColor;
    IconData severityIcon;

    switch (severity) {
      case 'High':
        severityColor = Colors.red;
        severityIcon = Icons.warning;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        severityIcon = Icons.info;
        break;
      case 'Low':
        severityColor = Colors.green;
        severityIcon = Icons.check_circle;
        break;
      default:
        severityColor = Colors.grey;
        severityIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(severityIcon, color: severityColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary: ${analysis.summary}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Severity: $severity | Priority: $priority',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionCard(BuildContext context, Detection detection) {
    Color severityColor;
    IconData severityIcon;

    switch (detection.severity) {
      case 'High':
        severityColor = Colors.red;
        severityIcon = Icons.warning;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        severityIcon = Icons.info;
        break;
      case 'Low':
        severityColor = Colors.green;
        severityIcon = Icons.check_circle;
        break;
      default:
        severityColor = Colors.grey;
        severityIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(severityIcon, color: severityColor, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detection.className,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confidence: ${(detection.confidence * 100).toStringAsFixed(1)}% | Severity: ${detection.severity} | Priority: ${detection.priority}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


