// lib/screens/rewards/redeem_rewards_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reward_controller.dart'; // Assuming you have this
import '../../models/coupon.dart';
import '../../widgets/coupon_card.dart';
import '../../widgets/rewards_panel_widget.dart';

class RedeemRewardsPage extends StatelessWidget {
  const RedeemRewardsPage({super.key});

  // Dummy data moved outside the build method for better performance
  static final List<Coupon> _coupons = [
    Coupon(id: 'PIZZA30', title: "30% Off on Pizza", description: "Valid at any Domino's outlet", cost: 150, icon: Icons.local_pizza, color: Colors.red.shade400, validTill: DateTime.now().add(const Duration(days: 30))),
    Coupon(id: 'COFFEEFREE', title: "Free Coffee", description: "Get one free coffee at Starbucks", cost: 100, icon: Icons.coffee, color: Colors.brown.shade400, validTill: DateTime.now().add(const Duration(days: 15))),
    Coupon(id: 'RECHARGE50', title: "₹50 Mobile Recharge", description: "Valid for any prepaid carrier", cost: 200, icon: Icons.phone_android, color: Colors.blue.shade400, validTill: DateTime.now().add(const Duration(days: 60))),
    Coupon(id: 'MUSIC1M', title: "1 Month Music Subscription", description: "For Spotify or Gaana", cost: 300, icon: Icons.music_note, color: Colors.green.shade400, validTill: DateTime.now().subtract(const Duration(days: 5))),
    Coupon(id: 'MOVIE100', title: "Movie Ticket Voucher", description: "Flat ₹100 off on BookMyShow", cost: 250, icon: Icons.movie, color: Colors.purple.shade400, validTill: DateTime.now().add(const Duration(days: 45))),
  ];

  void _showRedeemDialog(BuildContext context, Coupon coupon) {
    // Assuming you have a RewardController to get user points
    final rewardCtrl = Get.find<RewardController>();
    final canAfford = rewardCtrl.totalPoints.value >= coupon.cost;

    Get.dialog(
      AlertDialog(
        title: Text('confirmRedemption'.tr),
        content: Text('${'redeemFor'.tr} "${coupon.title}" ${'for'.tr} ${coupon.cost} ${'points'.tr}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: canAfford
                ? () {
              // Actual redemption logic would go here
              Get.back();
              Get.snackbar(
                'success'.tr,
                '${'voucherRedeemed'.tr}!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }
                : null, // Disable button if user cannot afford
            child: Text('redeem'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableCoupons = _coupons.where((c) => !c.isExpired).toList();
    final expiredCoupons = _coupons.where((c) => c.isExpired).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('redeemVouchersTitle'.tr),
          bottom: TabBar(
            tabs: [
              Tab(text: 'available'.tr),
              Tab(text: 'expired'.tr),
            ],
          ),
        ),
        body: Column(
          children: [
            // Your points panel is now more prominent
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: RewardsPanelWidget(),
            ),
            // The TabBarView takes up the remaining space
            Expanded(
              child: TabBarView(
                children: [
                  // Available Coupons Tab
                  _buildCouponList(
                    context: context,
                    coupons: availableCoupons,
                    isAvailable: true,
                    emptyMessage: 'noAvailableCoupons'.tr,
                  ),
                  // Expired Coupons Tab
                  _buildCouponList(
                    context: context,
                    coupons: expiredCoupons,
                    isAvailable: false,
                    emptyMessage: 'noExpiredCoupons'.tr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponList({
    required BuildContext context,
    required List<Coupon> coupons,
    required bool isAvailable,
    required String emptyMessage,
  }) {
    if (coupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(emptyMessage, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return Opacity(
          opacity: isAvailable ? 1.0 : 0.5, // De-emphasize expired coupons
          child: GestureDetector(
            onTap: isAvailable ? () => _showRedeemDialog(context, coupon) : null,
            child: CouponCard(coupon: coupon),
          ),
        );
      },
    );
  }
}