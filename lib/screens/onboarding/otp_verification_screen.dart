// lib/screens/onboarding/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_service.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final otpCtrl = TextEditingController();
    final apiService = Get.find<ApiService>();
    final email = Get.arguments as String;
    var isLoading = false.obs;

    return Scaffold(
      appBar: AppBar(title: Text('verifyOtp'.tr)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text('enterOtp'.tr, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextFormField(controller: otpCtrl, decoration: const InputDecoration(labelText: 'OTP'), keyboardType: TextInputType.number, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, letterSpacing: 8), maxLength: 6),
                  const SizedBox(height: 24),
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading.value ? null : () async {
                        if (otpCtrl.text.length == 6) {
                          isLoading.value = true;
                          bool success = await apiService.verifyOtp(email, otpCtrl.text);
                          if (success) Get.offAllNamed('/verify-face');
                          isLoading.value = false;
                        } else {
                          Get.snackbar('Error', 'OTP must be 6 digits.');
                        }
                      },
                      child: isLoading.value ? const CircularProgressIndicator(color: Colors.white) : Text('verifyOtp'.tr),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


