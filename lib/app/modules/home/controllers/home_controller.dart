import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  void onScanPressed() => Get.toNamed(Routes.analyzing);
  void onHistoryPressed() => Get.toNamed(Routes.history);
  void onGuidePressed() => Get.toNamed(Routes.guide);
  void onHelpsupportPressed() => Get.toNamed(Routes.helpSupport);
  void onIndependencesupportPressed() => Get.toNamed(Routes.independenceSupport);

  // TODO: 개발 테스트용 — 배포 전 제거
  void onResultTestPressed() => Get.toNamed(Routes.result);
}
