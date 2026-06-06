import 'package:get/get.dart';
import '../controllers/guide_detail_controller.dart';

class GuideDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuideDetailController>(() => GuideDetailController());
  }
}
