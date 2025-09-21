// lib/widgets/status_tracker.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusTracker extends StatelessWidget {
  final int currentIndex;
  const StatusTracker({super.key, required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    final statuses = ['created'.tr, 'approved'.tr, 'verified'.tr, 'resolved'.tr];
    return Column(
      children: List.generate(statuses.length, (index) {
        final isActive = index <= currentIndex;
        final isCompleted = index < currentIndex;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: isActive ? const Color(0xFF007BFF) : Colors.grey.shade300, child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null),
                  if (index < statuses.length - 1) Expanded(child: Container(width: 2, color: isCompleted ? const Color(0xFF007BFF) : Colors.grey.shade300)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(child: Padding(padding: EdgeInsets.only(bottom: index < statuses.length - 1 ? 24.0 : 0), child: Text(statuses[index], style: TextStyle(fontSize: 16, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? Colors.black87 : Colors.grey.shade500))))
            ],
          ),
        );
      }),
    );
  }
}


