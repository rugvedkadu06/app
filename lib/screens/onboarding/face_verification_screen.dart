// lib/screens/onboarding/face_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../../api/api_service.dart';

class FaceVerificationScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const FaceVerificationScreen({super.key, required this.cameras});
  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      // Use the front camera if available, otherwise the first camera
      final frontCamera = widget.cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => widget.cameras.first,
      );
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      _initializeControllerFuture = _controller?.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndUpload() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) {
      return;
    }
    try {
      setState(() => _isLoading = true);
      final image = await _controller!.takePicture();
      // Assuming ApiService is registered with GetX
      bool success = await Get.find<ApiService>().uploadFace(image);
      if (success) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'Face upload failed. Please try again.');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error capturing or uploading image: $e');
      Get.snackbar('Error', 'An error occurred. Please try again.');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no cameras are found, show a message and a skip button.
    if (widget.cameras.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('faceVerification'.tr)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No cameras found on this device."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.offAllNamed('/home'),
                child: const Text('Skip to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''.tr),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    'faceVerification'.tr,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Align your face inside the circle. For best results, use a well-lit area and remove glasses or masks.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 5.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (_controller != null &&
                            _controller!.value.isInitialized) {
                          return CameraPreview(_controller!);
                        } else {
                          return const Center(
                              child: Text('Error initializing camera.'));
                        }
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _captureAndUpload,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Verify My Face',
                          style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Get.offAllNamed('/home'),
                      child: Text('skipForNow'.tr,
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey.shade700)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
