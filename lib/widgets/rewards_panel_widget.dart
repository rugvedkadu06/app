// lib/widgets/rewards_panel_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';

class RewardsPanelWidget extends StatelessWidget {
  const RewardsPanelWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final rewardCtrl = Get.find<RewardController>();
    return Card(
      color: const Color(0xFF007BFF),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('totalCoins'.tr, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
                const SizedBox(height: 4),
                Obx(() => Text('${rewardCtrl.totalPoints.value}', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
            Icon(Icons.stars, size: 40, color: Colors.yellow.shade600),
          ],
        ),
      ),
    );
  }
}


