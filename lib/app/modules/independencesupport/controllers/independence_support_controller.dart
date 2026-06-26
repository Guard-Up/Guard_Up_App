import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // 전화 걸기
import '../../../data/models/institution_response.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';

/// 자립 지원 상담 화면 컨트롤러
class IndependenceSupportController extends GetxController {
  // API 통신 (data/providers/api_provider.dart)
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // 선택된 지역(광역시도) (null = 아직 선택 안 함)
  final selectedRegion = RxnString();

  // 조회 로딩 상태
  final isLoading = false.obs;

  // 조회 결과 (자립 지원 전담 기관 목록) — API 연결 전에는 비어 있음
  final results = <InstitutionItem>[].obs;

  // 조회를 한 번이라도 눌렀는지 (안내 문구 표시용)
  final hasSearched = false.obs;

  // 안내 문구에 쓸, 마지막으로 조회한 지역 이름
  final searchedRegion = RxnString();

  // 드롭다운에 표시할 광역시도 목록 (전담기관이 광역시도 단위라 17개)
  List<String> get regions => kRegions;

  // ── ViewModel getter (View는 이 값만 사용) ──────────────
  /// 조회 후 결과가 없을 때 보여줄 안내 문구
  String get emptyNoticeText =>
      '${searchedRegion.value ?? ''}의 자립 상담 기관은 추가 예정입니다.';

  /// 결과 없음 안내를 보여줄지 여부 (조회했고, 로딩 아니고, 결과 비었을 때)
  bool get showEmptyNotice =>
      hasSearched.value && !isLoading.value && results.isEmpty;

  /// 조회 버튼
  Future<void> onSearch() async {
    final region = selectedRegion.value;
    if (region == null) {
      Get.snackbar(
        '안내',
        '지역을 먼저 선택해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;
    searchedRegion.value = region;
    results.clear();

    try {
      // POST /api/institution → 해당 지역 전담기관 목록
      final res = await _apiProvider.getInstitution(region);
      results.assignAll(res.institutions);
    } on ApiException catch (e) {
      // 서버가 4xx/5xx 응답 (예: 해당 지역 데이터 없음)
      // results 가 비어 있으면 view 에서 "추가 예정" 안내가 자동으로 뜹니다.
      Get.log('getInstitution 실패: ${e.errorCode} - ${e.message}');
    } catch (e) {
      // 네트워크 오류 등
      Get.log('getInstitution 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 전화번호 탭 시 전화 앱 열기
  Future<void> callNumber(String phone) async {
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

/// 드롭다운용 광역시도 목록
const List<String> kRegions = [
  '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시',
  '대전광역시', '울산광역시', '세종특별자치시', '경기도', '강원특별자치도',
  '충청북도', '충청남도', '전북특별자치도', '전라남도', '경상북도',
  '경상남도', '제주특별자치도',
];