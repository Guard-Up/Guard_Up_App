import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/app_routes.dart';

/// 자립 지원 상담 화면 컨트롤러
class IndependenceSupportController extends GetxController {
  // 선택된 시 (null = 아직 선택 안 함)
  final selectedCity = RxnString();

  // 조회 로딩 상태
  final isLoading = false.obs;

  // 조회 결과 (자립 지원 전담 기관 목록) — API 연결 전에는 비어 있음
  final results = <SupportOrg>[].obs;

  // 조회를 한 번이라도 눌렀는지 (안내 문구 표시용)
  final hasSearched = false.obs;

  // 안내 문구에 쓸, 마지막으로 조회한 시 이름
  final searchedCity = RxnString();

  // 드롭다운에 표시할 한국의 시 목록
  List<String> get cities => koreaCities;

  /// 조회 버튼
  Future<void> onSearch() async {
    final city = selectedCity.value;
    if (city == null) {
      Get.snackbar(
        '안내',
        '시를 먼저 선택해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;
    searchedCity.value = city;
    results.clear();

    await Future.delayed(const Duration(milliseconds: 1500)); // 로딩 연출

    isLoading.value = false;
    // results 가 비어 있으면 view 에서 자동으로 "추가 예정입니다" 안내를 보여줍니다.
  }

  /// '바로가기' 탭 시 웹사이트 주소를 클립보드에 복사
  Future<void> copyWebsite(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar(
      '복사 완료',
      '웹사이트 주소가 복사되었어요.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  /// 전화번호 탭 시 전화 앱 열기
  Future<void> callNumber(String phone) async {
    // 숫자/＋ 외 문자(괄호, 공백 등) 제거
    final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$digits');
    try {
      final ok = await launchUrl(uri);
      if (!ok) _showCallError();
    } catch (_) {
      _showCallError();
    }
  }

  void _showCallError() {
    Get.snackbar(
      '안내',
      '전화 앱을 열 수 없어요.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // ─── 네비게이션 ────────────────────────────────────────
  void onHomePressed() => Get.offAllNamed(Routes.home); // 홈으로
  void onHistoryPressed() => Get.toNamed(Routes.history); // 최근 기록
  void onScanPressed() => Get.toNamed(Routes.scan); // 계약서 촬영

  void onUserPressed() {
    Get.snackbar(
      '안내',
      '사용자 페이지는 준비 중입니다.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}


class SupportOrg {
  final String address; // 주소
  final String websiteLabel; // 웹사이트 표시 이름 (예: 서울 자립전담기관)
  final String websiteUrl; // 실제 주소 (복사/이동용)
  final String phone; // 전화번호

  const SupportOrg({
    required this.address,
    required this.websiteLabel,
    required this.websiteUrl,
    required this.phone,
  });
}

/// 드롭다운용 한국의 시 목록
const List<String> koreaCities = [
  // 특별시 · 광역시 · 특별자치시
  '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시',
  '대전광역시', '울산광역시', '세종특별자치시',
  // 경기도
  '수원시', '성남시', '의정부시', '안양시', '부천시', '광명시', '평택시',
  '동두천시', '안산시', '고양시', '과천시', '구리시', '남양주시', '오산시',
  '시흥시', '군포시', '의왕시', '하남시', '용인시', '파주시', '이천시',
  '안성시', '김포시', '화성시', '광주시', '양주시', '포천시', '여주시',
  // 강원특별자치도
  '춘천시', '원주시', '강릉시', '동해시', '태백시', '속초시', '삼척시',
  // 충청북도
  '청주시', '충주시', '제천시',
  // 충청남도
  '천안시', '공주시', '보령시', '아산시', '서산시', '논산시', '계룡시', '당진시',
  // 전북특별자치도
  '전주시', '군산시', '익산시', '정읍시', '남원시', '김제시',
  // 전라남도
  '목포시', '여수시', '순천시', '나주시', '광양시',
  // 경상북도
  '포항시', '경주시', '김천시', '안동시', '구미시', '영주시', '영천시',
  '상주시', '문경시', '경산시',
  // 경상남도
  '창원시', '진주시', '통영시', '사천시', '김해시', '밀양시', '거제시', '양산시',
  // 제주특별자치도
  '제주시', '서귀포시',
];