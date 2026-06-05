import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class ScanController extends GetxController {
  CameraController? cameraController;
  final isInitialized = false.obs;
  final isCapturing = false.obs;
  final cameraError = RxnString();

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameraError.value = null;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        cameraError.value = '사용 가능한 카메라가 없습니다.';
        return;
      }

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isInitialized.value = true;
    } on CameraException catch (e) {
      log('카메라 초기화 실패: ${e.code}', name: 'ScanController', error: e);
      cameraError.value = e.code == 'cameraPermission'
          ? '카메라 권한이 필요합니다.\n설정에서 권한을 허용해주세요.'
          : '카메라를 시작할 수 없습니다.\n(${e.description ?? e.code})';
    } catch (e, st) {
      log('카메라 초기화 예외', name: 'ScanController', error: e, stackTrace: st);
      cameraError.value = '카메라를 시작할 수 없습니다.';
    }
  }

  Future<void> retryCamera() async {
    isInitialized.value = false;
    await cameraController?.dispose();
    cameraController = null;
    await _initCamera();
  }

  Future<void> onCapturePressed() async {
    final cam = cameraController;
    if (cam == null || !cam.value.isInitialized || isCapturing.value) return;

    isCapturing.value = true;
    try {
      final file = await cam.takePicture();
      Get.back(result: file.path);
    } finally {
      isCapturing.value = false;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
