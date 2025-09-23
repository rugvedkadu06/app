// lib/screens/onboarding/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_service.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final apiService = Get.find<ApiService>();
    var isLoading = false.obs;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Increased the logo size
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('createAccount'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          TextFormField(
                              controller: nameCtrl,
                              decoration:
                              InputDecoration(labelText: 'fullName'.tr),
                              validator: (v) => v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 16),
                          TextFormField(
                              controller: emailCtrl,
                              decoration: InputDecoration(
                                  labelText: 'emailAddress'.tr),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => !GetUtils.isEmail(v!)
                                  ? 'Valid email required'
                                  : null),
                          const SizedBox(height: 16),
                          TextFormField(
                              controller: phoneCtrl,
                              decoration: InputDecoration(
                                  labelText: 'phoneNumber'.tr),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 24),
                          Obx(() => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading.value
                                  ? null
                                  : () async {
                                if (formKey.currentState!
                                    .validate()) {
                                  isLoading.value = true;
                                  bool success = await apiService
                                      .sendOtp(nameCtrl.text,
                                      emailCtrl.text, phoneCtrl.text);
                                  if (success)
                                    Get.toNamed('/otp',
                                        arguments: emailCtrl.text);
                                  isLoading.value = false;
                                }
                              },
                              child: isLoading.value
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5),
                              )
                                  : Text('sendOtp'.tr),
                            ),
                          )),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(''.tr),
                              TextButton(
                                onPressed: () {
                                  // No action on click as requested
                                },
                                child: Text('Already Have Account'.tr),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}