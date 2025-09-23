import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import 'reward_list_page.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rewards & Offers'),
          backgroundColor: Colors.teal,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Redeem Rewards'),
              Tab(text: 'My Rewards'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const RewardListPage(),
            Obx(() => userCtrl.redeemedRewards.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: userCtrl.redeemedRewards.length,
                    itemBuilder: (context, index) {
                      final reward = userCtrl.redeemedRewards[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green, size: 32),
                          title: Text(reward.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text('Redemption Code: ${reward.code}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                              Text(
                                  'Redeemed on: ${reward.redeemedAt.day}/${reward.redeemedAt.month}/${reward.redeemedAt.year}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy,
                                color: Colors.blue),
                            onPressed: () {
                              // Copy code to clipboard functionality can be added here
                              Get.snackbar('Copied',
                                  'Code copied to clipboard: ${reward.code}');
                            },
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard_outlined,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No rewards redeemed yet',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600)),
                        Text('Start earning points to redeem exciting rewards!',
                            style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
