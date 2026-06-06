import 'package:get/get.dart';
import '../controllers/guide_qna_controller.dart';

class GuideQnaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuideQnaController>(() => GuideQnaController());
  }
}
