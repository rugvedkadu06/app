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
  bool _autoTriggered = false;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      final frontCamera = widget.cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front, orElse: () => widget.cameras.first);
      _controller = CameraController(frontCamera, ResolutionPreset.high, enableAudio: false);
      _initializeControllerFuture = _controller?.initialize();
      _initializeControllerFuture?.then((_) async {
        if (!mounted) return;
        if (!_autoTriggered) {
          _autoTriggered = true;
          await Future.delayed(const Duration(milliseconds: 800));
          if (mounted && !_isLoading) {
            _captureAndUpload();
          }
        }
      });
    }
  }

  @override
  void dispose() { _controller?.dispose(); super.dispose(); }

  Future<void> _captureAndUpload() async {
    if (_controller == null || _controller!.value.isTakingPicture) return;
    try {
      setState(() => _isLoading = true);
      final image = await _controller!.takePicture();
      bool success = await Get.find<ApiService>().uploadFace(image);
      if (success) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'Face upload failed. Please try again.');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Scaffold(appBar: AppBar(), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("No cameras found."), ElevatedButton(onPressed: ()=>Get.offAllNamed('/home'), child: const Text('Skip to Home'))])));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 20.0), child: Column(children: [
              Text('faceVerification'.tr, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 8),
              const Text('Align your face inside the circle. Good light, remove glasses/mask.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            ])),
            Expanded(
              child: Center(
                child: Container(
                  width: 300, height: 400, clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.indigo.shade700, width: 4.0)),
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) return Stack(children: [
                        Positioned.fill(child: CameraPreview(_controller!)),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                            child: const Text('Tip: Hold steady and keep your face centered', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                          ),
                        )
                      ]);
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : InkWell(
                        onTap: _captureAndUpload,
                        borderRadius: BorderRadius.circular(40),
                        child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.shade600), child: const Icon(Icons.check, color: Colors.white, size: 40)),
                      ),
                    ),
                  ),
                  if (!_isLoading) Padding(padding: const EdgeInsets.only(top: 8.0), child: TextButton(onPressed: () => Get.offAllNamed('/home'), child: Text('skipForNow'.tr))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


