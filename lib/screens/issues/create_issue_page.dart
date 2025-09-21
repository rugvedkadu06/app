// lib/screens/issues/create_issue_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/google_map_widget.dart';
import 'preview_issue_page.dart';

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw some map-like elements
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw roads
    final roadPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Horizontal road
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      roadPaint,
    );

    // Vertical road
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      roadPaint,
    );

    // Draw some buildings
    final buildingPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    // Building 1
    canvas.drawRect(
      Rect.fromLTWH(centerX - 40, centerY - 30, 20, 20),
      buildingPaint,
    );

    // Building 2
    canvas.drawRect(
      Rect.fromLTWH(centerX + 20, centerY + 10, 25, 15),
      buildingPaint,
    );

    // Building 3
    canvas.drawRect(
      Rect.fromLTWH(centerX - 60, centerY + 20, 15, 25),
      buildingPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CreateIssuePage extends StatefulWidget {
  const CreateIssuePage({super.key});
  @override
  State<CreateIssuePage> createState() => _CreateIssuePageState();
}
class _CreateIssuePageState extends State<CreateIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  XFile? _imageFile;
  String? _locationMessage;
  bool _isFetchingLocation = false;
  double? _latitude;
  double? _longitude;
  Future<void> _getImageFromCamera() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() => _imageFile = image);
  }

  Future<void> _getImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() => _imageFile = image);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'selectImageSource'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _getImageFromCamera();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _getImageFromGallery();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue.shade600),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapDisplay() {
    return GoogleMapWidget(
      latitude: _latitude!,
      longitude: _longitude!,
      title: 'Issue Location',
      description: 'Tap to view on full screen',
      height: 200,
      isInteractive: true,
      onTap: (LatLng position) => _showFullMap(),
    );
  }

  void _showFullMap() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMapWidget(
                  latitude: _latitude!,
                  longitude: _longitude!,
                  title: 'Issue Location',
                  description: 'Current location for issue report',
                  height: MediaQuery.of(context).size.height * 0.8,
                  isInteractive: true,
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() { _isFetchingLocation = true; _locationMessage = 'fetchingLocation'.tr; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) { setState(() => _locationMessage = 'Location services are disabled.'); return; }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) { setState(() => _locationMessage = 'Location permissions are denied'); return; }
      }
      if (permission == LocationPermission.deniedForever) { setState(() => _locationMessage = 'Location permissions are permanently denied.'); return; }
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _locationMessage = "${place.street}, ${place.locality}";
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) { setState(() => _locationMessage = "Failed to get location."); }
    finally { setState(() => _isFetchingLocation = false); }
  }
  void _onPreview() {
    if (_formKey.currentState!.validate() && _locationMessage != null && !_locationMessage!.contains('...')) {
      Get.to(() => PreviewIssuePage(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        location: '${_landmarkCtrl.text}, $_locationMessage',
        imageFile: _imageFile,
        userName: Get.find<UserController>().user.value.name,
        latitude: _latitude,
        longitude: _longitude,
      ));
    } else {
      Get.snackbar('Error', 'Please fill all fields and fetch location.', snackPosition: SnackPosition.BOTTOM);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('createIssue'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(controller: _titleCtrl, decoration: InputDecoration(labelText: 'issueTitle'.tr), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _descCtrl, decoration: InputDecoration(labelText: 'description'.tr), maxLines: 4, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _landmarkCtrl, decoration: InputDecoration(labelText: 'nearbyLandmark'.tr), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF007BFF)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_locationMessage ?? 'Location not fetched yet.')),
                      if (_isFetchingLocation)
                        const SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
                      else
                        IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: _getCurrentLocation,
                        ),
                    ],
                  ),
                ),
              ),
              if (_latitude != null && _longitude != null) ...[
                const SizedBox(height: 16),
                _buildMapDisplay(),
              ],
              const SizedBox(height: 16),
              if (_imageFile != null) ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(_imageFile!.path), height: 200, width: double.infinity, fit: BoxFit.cover)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.add_a_photo),
                  label: Text(_imageFile != null ? 'changePhoto'.tr : 'addPhoto'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _onPreview, child: Text('previewIssue'.tr))),
            ],
          ),
        ),
      ),
    );
  }
}


