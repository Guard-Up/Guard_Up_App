import 'package:get/get.dart';
import '../controllers/independence_support_controller.dart';

class IndependenceSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndependenceSupportController>(
      () => IndependenceSupportController(),
    );
  }
}
