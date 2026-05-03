import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_routes.dart';

class ScanController extends GetxController {
  final _picker = ImagePicker();
  final isLoading = false.obs;

  Future<void> onCameraPressed() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    await _navigateToAnalyzing(file);
  }

  Future<void> onGalleryPressed() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    await _navigateToAnalyzing(file);
  }

  Future<void> _navigateToAnalyzing(XFile file) async {
    isLoading.value = true;
    try {
      final bytes = await File(file.path).readAsBytes();
      final base64Image = base64Encode(bytes);
      Get.toNamed(Routes.analyzing, arguments: {'base64Image': base64Image});
    } finally {
      isLoading.value = false;
    }
  }
}
