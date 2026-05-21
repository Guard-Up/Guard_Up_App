import 'package:get/get.dart';

class AnalysisController extends GetxController {
  // 사용 이력 관리용 Observable 변수
  var recentHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    // 💡 이 리스트가 비어있으면(recentHistory.clear()) 자동으로 사용 이력이 없는 왼쪽 화면이 됩니다.
    recentHistory.value = [
      {'icon': 'shield', 'type': '월세', 'address': '서울시 강남대로\n123길 123로', 'status': '안전 10', 'color': 0xFF66BB6A},
      {'icon': 'home', 'type': '전세', 'address': '서울시 강남대로\n123길 123로', 'status': '위험 85', 'color': 0xFFEF5350},
      {'icon': 'shield', 'type': '전세', 'address': '서울시 강남대로\n123길 123로', 'status': '보통 55', 'color': 0xFFFFCA28},
    ];
  }

  void openCamera() => Get.snackbar('카메라', '계약서 촬영을 시작합니다.');
  void uploadFile() => Get.snackbar('파일 업로드', '파일 탐색기를 엽니다.');
  void goToHistory() => Get.toNamed('/history');

  void onTabTapped(int index) {
    if (index == 0) Get.toNamed('/history');
    if (index == 2) Get.toNamed('/support');
  }
}