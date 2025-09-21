// lib/screens/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/issue_controller.dart';
import '../../api/api_service.dart';
import '../../models/issue.dart';
import '../../widgets/info_chip.dart';
import '../../widgets/stat_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final issueCtrl = Get.find<IssueController>();
    final apiService = Get.find<ApiService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Obx(() => CircleAvatar(radius: 40, backgroundColor: Colors.indigo, backgroundImage: userCtrl.user.value.faceImageUrl != null ? NetworkImage(userCtrl.user.value.faceImageUrl!) : null, child: userCtrl.user.value.faceImageUrl == null ? Text(userCtrl.user.value.name.isNotEmpty ? userCtrl.user.value.name.substring(0, 2) : 'G', style: const TextStyle(fontSize: 24, color: Colors.white)) : null)),
                  const SizedBox(height: 16),
                  Obx(() => Text(userCtrl.user.value.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 8),
                  Obx(() => InfoChip(icon: Icons.email_outlined, text: userCtrl.user.value.email)),
                  const SizedBox(height: 4),
                  Obx(() => InfoChip(icon: Icons.phone_outlined, text: userCtrl.user.value.phone)),
                  const SizedBox(height: 4),
                  Obx(() => InfoChip(icon: Icons.badge_outlined, text: '${'uniqueId'.tr}: ${userCtrl.user.value.uniqueId}')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('yourStats'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Obx(() => Row(
            children: [
              Expanded(child: StatCard(label: 'issuesCreated'.tr, value: issueCtrl.issues.length.toString(), color: Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(label: 'issuesResolved'.tr, value: issueCtrl.issues.where((i) => i.status == IssueStatus.resolved).length.toString(), color: Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(label: 'issuesApproved'.tr, value: issueCtrl.issues.where((i) => i.status == IssueStatus.approved).length.toString(), color: Colors.orange)),
            ],
          )),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.logout), label: Text('logout'.tr), onPressed: () => apiService.logout(), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600))),
        ],
      ),
    );
  }
}


