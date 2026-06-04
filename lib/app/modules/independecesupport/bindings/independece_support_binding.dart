import 'package:get/get.dart';
import '../controllers/independece_support_controller.dart';

class IndependeceSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndependeceSupportController>(
      () => IndependeceSupportController(),
    );
  }
}
