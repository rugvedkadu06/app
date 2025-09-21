// lib/widgets/issue_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/issue.dart';
import '../screens/issues/issue_detail_page.dart';
import 'status_chip.dart';
import 'info_chip.dart';

class IssueCard extends StatelessWidget {
  final Issue issue;
  const IssueCard({super.key, required this.issue});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(() => IssueDetailPage(issue: issue)),
        child: Row(
          children: [
            SizedBox(
              width: 100, 
              height: 100, 
              child: issue.imageUrl != null && issue.imageUrl!.isNotEmpty 
                ? Image.network(issue.imageUrl!, fit: BoxFit.cover)
                : issue.imagePath != null && issue.imagePath!.isNotEmpty 
                  ? Image.file(File(issue.imagePath!), fit: BoxFit.cover)
                  : Image.network(issue.placeholderImageUrl, fit: BoxFit.cover)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(issue.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    InfoChip(icon: Icons.location_on_outlined, text: issue.location),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        StatusChip(status: issue.status),
                        if (issue.aiAnalysis != null && issue.aiAnalysis!.detections.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _buildAiAnalysisChip(context),
                        ],
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

  Widget _buildAiAnalysisChip(BuildContext context) {
    final analysis = issue.aiAnalysis!;
    final severity = analysis.highestSeverity;
    
    Color chipColor;
    IconData chipIcon;
    
    switch (severity) {
      case 'High':
        chipColor = Colors.red.shade100;
        chipIcon = Icons.warning;
        break;
      case 'Medium':
        chipColor = Colors.orange.shade100;
        chipIcon = Icons.info;
        break;
      case 'Low':
        chipColor = Colors.green.shade100;
        chipIcon = Icons.check_circle;
        break;
      default:
        chipColor = Colors.grey.shade100;
        chipIcon = Icons.help;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chipIcon, size: 14, color: chipColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white),
          const SizedBox(width: 4),
          Text(
            'AI: ${analysis.detections.length} issue${analysis.detections.length > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: chipColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


