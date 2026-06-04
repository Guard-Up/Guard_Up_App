import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/history_item.dart';
import '../../../data/models/risk_analysis_response.dart';
import '../../../routes/app_routes.dart';
import '../../../services/local_storage_service.dart';

enum ResultDisplayState { loading, revealing, ready }

class ResultController extends GetxController {
  final _storageService = Get.find<LocalStorageService>();

  RiskAnalysisResponse? _result;
  String _address = '';

  RiskAnalysisResponse get result => _result!;
  String get address => _address;

  final displayState = ResultDisplayState.loading.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      final rawResult = args['result'];
      final rawAddress = args['address'];
      if (rawResult is RiskAnalysisResponse) {
        _result = rawResult;
        _address = rawAddress is String ? rawAddress : '';
        final isFromHistory = args['fromHistory'] == true;
        if (isFromHistory) {
          displayState.value = ResultDisplayState.ready;
        } else {
          _saveToHistory();
        }
        return;
      }
    }
    Get.back();
  }

  Future<void> _saveToHistory() async {
    try {
      await _storageService.init();
      await _storageService.saveHistory(HistoryItem(
        address: address,
        score: result.score,
        level: result.level,
        issues: result.issues,
        actionGuide: result.actionGuide,
        publicData: result.publicData,
        createdAt: DateTime.now(),
      ));
    } catch (e, st) {
      log('히스토리 저장 실패', name: 'ResultController', error: e, stackTrace: st);
    } finally {
      displayState.value = ResultDisplayState.revealing;
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!isClosed) displayState.value = ResultDisplayState.ready;
    }
  }

  // ─── 점수 카드 ───────────────────────────────────────────
  String get scoreText => '${result.score}';
  String get levelLabel => result.level.label;
  String get levelMessage => result.level.message;
  Color get levelColor => result.level.color;

  // ─── 확인된 문제 카드 ────────────────────────────────────
  int get issueCount => result.issues.length;

  List<Issue> get issues => result.issues;

  String get issueMessage {
    switch (result.level) {
      case RiskLevel.safe:
        return '계약을 진행해도 안전합니다.';
      case RiskLevel.caution:
        return '한번 더 검토하고 진행하세요.';
      case RiskLevel.danger:
        return '계약을 중지하고 전문가와 상담하세요.';
    }
  }

  // ─── 가이드 카드 1: 법적 위반 (isLegalBasis == true) ─────
  List<Issue> get legalIssues =>
      result.issues.where((i) => i.isLegalBasis).toList();

  bool get hasLegalIssues => legalIssues.isNotEmpty;

  String get legalGuideTitleText => '강행규정 위반 · 무효 가능성';

  String get legalGuideBodyText =>
      '아래 조항은 법적 강행규정을 위반하여 무효가 될 수 있습니다.\n'
      '반드시 전문가와 상담 후 계약 여부를 결정하세요.';

  // ─── 가이드 카드 2: 일반 위험 (isLegalBasis == false) ────
  List<Issue> get generalIssues =>
      result.issues.where((i) => !i.isLegalBasis).toList();

  bool get hasGeneralIssues => generalIssues.isNotEmpty;

  String get generalGuideTitleText => '검토 권장 항목';

  String get generalGuideBodyText =>
      '법적 강제 사항은 아니나, 계약 전 충분히 검토하고 본인이 판단하세요.';

  // ─── 네비게이션 ──────────────────────────────────────────
  void onBackPressed() => Get.offAllNamed(Routes.home);
  void onScanPressed() => Get.toNamed(Routes.analyzing);
  void onHistoryPressed() => Get.toNamed(Routes.history);

}
