import 'package:get/get.dart';

class HomeController extends GetxController {
  // 하단 탭 인덱스 (초기값 -1로 설정하여 아무것도 선택되지 않은 상태로 시작)
  var tabIndex = 0.obs;

  // 탭 클릭 시 각 화면으로 이동
  void onTabTapped(int index) {
    tabIndex.value = index;
    switch (index) {
      case 0: // 메뉴바 (기록)
        Get.toNamed('/history');
        break;
      case 1: // 카메라 (분석)
        Get.toNamed('/analysis');
        break;
      case 2: // 사람 (자립지원 상담 - 임시 경로)
        Get.toNamed('/support');
        break;
    }
  }

  void goToAnalysis() => Get.toNamed('/analysis');
  void goToHistory() => Get.toNamed('/history');
  void goToSupport() => Get.toNamed('/support');
}