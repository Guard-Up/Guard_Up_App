import 'package:get/get.dart';
import '../../../data/models/history_model.dart'; // 수정된 모델 파일 임포트

class HistoryController extends GetxController {
  // 관찰 가능한(Observable) 변수 선언 (.obs)
  var isLoading = true.obs;
  var historyList = <HistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLocalHistoryData(); // 화면이 켜질 때 로컬 데이터 불러오기
  }

  // 🌟 GuardUp 핵심 규칙: 서버가 아닌 기기 내부 저장소에서 데이터를 읽어옵니다.
  Future<void> loadLocalHistoryData() async {
    isLoading.value = true;

    // TODO: 추후 sqflite 또는 shared_preferences 연동 코드가 들어갈 자리입니다.
    await Future.delayed(const Duration(milliseconds: 600)); // 로컬 DB 가상 딜레이

    // 임시 테스트용 데이터 세팅
    historyList.value = [
      HistoryModel(id: '1', type: '월세', address: '서울시 송파구 올림픽로\n240', date: '26.05.18', score: 15),
      HistoryModel(id: '2', type: '전세', address: '서울시 송파구 올림픽로\n300', date: '26.05.19', score: 88),
      HistoryModel(id: '3', type: '전세', address: '경기도 수원시 권선구\n새말로 45', date: '26.05.21', score: 45),
    ];

    isLoading.value = false; // 로딩 끝! 화면 새로고침 트리거
  }
}