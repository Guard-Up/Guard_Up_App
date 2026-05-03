import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  void onScanPressed() => Get.toNamed(Routes.scan);
  void onHistoryPressed() => Get.toNamed(Routes.history);
  void onGuidePressed() => Get.toNamed(Routes.guide);
}
