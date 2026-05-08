import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_routes.dart';

class ScanController extends GetxController {
  final _picker = ImagePicker();
  final isLoading = false.obs;

  Future<void> onCameraPressed() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    _navigateToAnalyzing(file);
  }

  Future<void> onGalleryPressed() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    _navigateToAnalyzing(file);
  }

  void _navigateToAnalyzing(XFile file) {
    Get.toNamed(Routes.analyzing, arguments: {'imagePath': file.path});
  }
}
