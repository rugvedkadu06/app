class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final issueCtrl = Get.find<IssueController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search issues...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) => issueCtrl.searchIssues(query),
          ),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: issueCtrl.filteredIssues.length,
                itemBuilder: (context, index) {
                  final issue = issueCtrl.filteredIssues[index];
                  // ...existing issue list item code...
                },
              )),
        ),
      ],
    );
  }
}
