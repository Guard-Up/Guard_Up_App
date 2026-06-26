import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../controllers/independence_support_controller.dart';

class IndependenceSupportBinding extends Bindings {
  @override
  void dependencies() {
    // ApiProvider 가 아직 등록 안 됐으면 등록 (앱 전역 공용)
    if (!Get.isRegistered<ApiProvider>()) {
      Get.put<ApiProvider>(ApiProvider(), permanent: true);
    }
    Get.lazyPut<IndependenceSupportController>(
      () => IndependenceSupportController(),
    );
  }
}