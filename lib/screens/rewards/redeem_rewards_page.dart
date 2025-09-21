// lib/screens/rewards/redeem_rewards_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/coupon.dart';
import '../../widgets/coupon_card.dart';
import '../../widgets/rewards_panel_widget.dart';

class RedeemRewardsPage extends StatelessWidget {
  const RedeemRewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Coupon> coupons = [
      Coupon(id: 'PIZZA30', title: "30% Off on Pizza", description: "Valid at any Domino's outlet", cost: 150, icon: Icons.local_pizza, color: Colors.red.shade400, validTill: DateTime.now().add(const Duration(days: 30))),
      Coupon(id: 'COFFEEFREE', title: "Free Coffee", description: "Get one free coffee at Starbucks", cost: 100, icon: Icons.coffee, color: Colors.brown.shade400, validTill: DateTime.now().add(const Duration(days: 15))),
      Coupon(id: 'RECHARGE50', title: "₹50 Mobile Recharge", description: "Valid for any prepaid carrier", cost: 200, icon: Icons.phone_android, color: Colors.blue.shade400, validTill: DateTime.now().add(const Duration(days: 60))),
      Coupon(id: 'MUSIC1M', title: "1 Month Music Subscription", description: "For Spotify or Gaana", cost: 300, icon: Icons.music_note, color: Colors.green.shade400, validTill: DateTime.now().subtract(const Duration(days: 5))),
      Coupon(id: 'MOVIE100', title: "Movie Ticket Voucher", description: "Flat ₹100 off on BookMyShow", cost: 250, icon: Icons.movie, color: Colors.purple.shade400, validTill: DateTime.now().add(const Duration(days: 45))),
    ];

    final availableCoupons = coupons.where((c) => !c.isExpired).toList();
    final expiredCoupons = coupons.where((c) => c.isExpired).toList();

    return Scaffold(
      appBar: AppBar(title: Text('redeemVouchersTitle'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RewardsPanelWidget(),
            const SizedBox(height: 24),
            Text('availableVouchers'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableCoupons.length,
              itemBuilder: (context, index) => CouponCard(coupon: availableCoupons[index]),
            ),
            const SizedBox(height: 24),
            if(expiredCoupons.isNotEmpty) ...[
              Text('expiredVouchers'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expiredCoupons.length,
                itemBuilder: (context, index) => CouponCard(coupon: expiredCoupons[index]),
              ),
            ]
          ],
        ),
      ),
    );
  }
}


