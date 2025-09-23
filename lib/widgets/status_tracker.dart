// lib/widgets/status_tracker.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusTracker extends StatelessWidget {
  final int currentIndex;

  const StatusTracker({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final List<String> statuses = [
      'created'.tr,
      'approved'.tr,
      'verified'.tr,
      'resolved'.tr
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(statuses.length, (index) {
        return _StatusStepNode(
          title: statuses[index],
          isActive: index <= currentIndex,
          isCompleted: index < currentIndex,
          isLastStep: index == statuses.length - 1,
        );
      }),
    );
  }
}

/// A private widget representing a single node in the status tracker.
class _StatusStepNode extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool isCompleted;
  final bool isLastStep;

  const _StatusStepNode({
    required this.title,
    required this.isActive,
    required this.isCompleted,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = Theme.of(context).dividerColor;
    const animationDuration = Duration(milliseconds: 300);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator Column: Dot and connecting line
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Animated Dot
              AnimatedContainer(
                duration: animationDuration,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? activeColor : (isActive ? activeColor : Theme.of(context).scaffoldBackgroundColor),
                  border: Border.all(
                    width: 2,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                ),
                child: _buildIcon(context),
              ),
              // Animated Connecting Line
              if (!isLastStep)
                Expanded(
                  child: AnimatedContainer(
                    duration: animationDuration,
                    width: 2,
                    color: isCompleted ? activeColor : inactiveColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Text Label
          Expanded(
            child: Padding(
              // Add padding to the bottom of all but the last item
              padding: EdgeInsets.only(
                top: 2, // Minor adjustment to align text with center of dot
                bottom: isLastStep ? 0 : 32.0,
              ),
              child: AnimatedDefaultTextStyle(
                duration: animationDuration,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.black87 : Colors.grey.shade600,
                ),
                child: Text(title),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build the icon inside the dot based on state.
  Widget _buildIcon(BuildContext context) {
    if (isCompleted) {
      return const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (isActive) {
      // Show an inner dot for the current, non-completed step
      return Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      );
    }
    // Return an empty container for inactive steps
    return Container();
  }
}