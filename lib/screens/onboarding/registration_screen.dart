// lib/screens/onboarding/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_service.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController(), emailCtrl = TextEditingController(), phoneCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final apiService = Get.find<ApiService>();
    var isLoading = false.obs;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('createAccount'.tr, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      TextFormField(controller: nameCtrl, decoration: InputDecoration(labelText: 'fullName'.tr), validator: (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 16),
                      TextFormField(controller: emailCtrl, decoration: InputDecoration(labelText: 'emailAddress'.tr), keyboardType: TextInputType.emailAddress, validator: (v) => !GetUtils.isEmail(v!) ? 'Valid email required' : null),
                      const SizedBox(height: 16),
                      TextFormField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'phoneNumber'.tr), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 24),
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading.value ? null : () async {
                            if (formKey.currentState!.validate()) {
                              isLoading.value = true;
                              bool success = await apiService.sendOtp(nameCtrl.text, emailCtrl.text, phoneCtrl.text);
                              if (success) Get.toNamed('/otp', arguments: emailCtrl.text);
                              isLoading.value = false;
                            }
                          },
                          child: isLoading.value ? const CircularProgressIndicator(color: Colors.white) : Text('sendOtp'.tr),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


