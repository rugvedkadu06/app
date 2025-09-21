// lib/screens/rewards/reward_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reward_controller.dart';
import '../../widgets/rewards_panel_widget.dart';
import 'redeem_rewards_page.dart';
import 'package:intl/intl.dart';

class RewardListPage extends StatelessWidget {
  const RewardListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RewardsPanelWidget(),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.card_giftcard), label: Text('redeemRewards'.tr), onPressed: () => Get.to(() => const RedeemRewardsPage()))),
          const SizedBox(height: 24),
          Text('transactions'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GetX<RewardController>(
              builder: (rewardCtrl) {
                if (rewardCtrl.transactions.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(32.0), child: Text('noTransactions'.tr)));
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rewardCtrl.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = rewardCtrl.transactions[index];
                    final isCredit = transaction.points > 0;
                    return Card(child: ListTile(leading: Icon(isCredit ? Icons.add_circle : Icons.remove_circle, color: isCredit ? Colors.green : Colors.red), title: Text(transaction.note), subtitle: Text(DateFormat.yMMMd().add_jm().format(transaction.date)), trailing: Text('${isCredit ? '+' : ''}${transaction.points}', style: TextStyle(color: isCredit ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16))));
                  },
                );
              }
          )
        ],
      ),
    );
  }
}


