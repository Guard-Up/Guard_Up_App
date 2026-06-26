import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/app_routes.dart';

/// 피해 상담 화면 컨트롤러
class HelpSupportController extends GetxController {
  /// 국토부 연결 링크 → 웹페이지 열기
  Future<void> openMolitWebsite() async {
    // 국토교통부 전세사기 피해지원 안내 페이지 (필요 시 주소만 바꾸면 됨)
    final uri = Uri.parse('https://www.molit.go.kr');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) _showOpenError();
    } catch (_) {
      _showOpenError();
    }
  }

  void _showOpenError() {
    Get.snackbar(
      '안내',
      '웹페이지를 열 수 없어요. 잠시 후 다시 시도해주세요.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
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

  // ─── 네비게이션 (자립상담과 동일) ──────────────────────
  void onHomePressed() => Get.offAllNamed(Routes.home); // 홈으로
  void onHistoryPressed() => Get.toNamed(Routes.history); // 최근 기록
  void onScanPressed() => Get.toNamed(Routes.scan); // 계약서 촬영

  void onUserPressed() {
    // TODO: 사용자(프로필) 페이지가 생기면 Routes.user 로 연결
    Get.snackbar(
      '안내',
      '사용자 페이지는 준비 중입니다.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}