// lib/screens/issues/issue_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/issue_controller.dart';
import '../../widgets/issue_card_placeholder.dart';
import '../../widgets/issue_card.dart';

class IssueListPage extends StatelessWidget {
  const IssueListPage({super.key});
  @override
  Widget build(BuildContext context) {
    final issueCtrl = Get.find<IssueController>();
    final statuses = ['all', 'pending', 'approved', 'inProgress', 'resolved'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'searchIssues'.tr, 
                    prefixIcon: const Icon(Icons.search), 
                    filled: true, 
                    fillColor: Colors.white, 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), 
                      borderSide: BorderSide.none
                    )
                  )
                )
              ),
              const SizedBox(width: 8),
              Obx(() => IconButton(
                onPressed: issueCtrl.toggleActiveIssues,
                icon: Icon(
                  issueCtrl.showActiveIssues.value ? Icons.public : Icons.person,
                  color: issueCtrl.showActiveIssues.value ? Colors.blue : Colors.grey,
                ),
                tooltip: issueCtrl.showActiveIssues.value ? 'Show My Issues' : 'Show All Issues',
              )),
            ],
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Obx(() => Text(
                  issueCtrl.showActiveIssues.value ? 'All Active Issues' : 'My Issues',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: statuses.map((status) {
              return Obx(() => Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: ChoiceChip(label: Text(status.tr), selected: issueCtrl.selectedStatus.value == status, onSelected: (isSelected) { if (isSelected) issueCtrl.filterByStatus(status); })));
            }).toList(),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (issueCtrl.isLoading.value) return ListView.builder(padding: const EdgeInsets.fromLTRB(16, 16, 16, 16), itemCount: 5, itemBuilder: (context, index) => const IssueCardPlaceholder());
            if (issueCtrl.filteredIssues.isEmpty) return Center(child: Text('noIssues'.tr));
            return RefreshIndicator(
              onRefresh: () => issueCtrl.loadIssues(),
              child: ListView.builder(padding: const EdgeInsets.fromLTRB(16, 16, 16, 16), itemCount: issueCtrl.filteredIssues.length, itemBuilder: (context, index) => IssueCard(issue: issueCtrl.filteredIssues[index])),
            );
          }),
        ),
      ],
    );
  }
}


