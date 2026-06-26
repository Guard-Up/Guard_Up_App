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
      } else {
        _result = _mockResult;
        _address = '';
        _saveToHistory();
      }
    } else {
      _result = _mockResult;
      _address = '서울시 강남구 테헤란로 123';
      _saveToHistory();
    }
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
  void onHelpSupportPressed() => Get.toNamed(Routes.helpSupport);

  // TODO: 테스트용 — 배포 전 제거
  void onResultTestPressed() => Get.toNamed(Routes.result);

  static final _mockResult = RiskAnalysisResponse(
    score: 18,
    level: RiskLevel.danger,
    issues: [
      Issue(
        clause: '전세보증금 반환 조항 부재',
        reason: '계약 종료 후 보증금 반환 의무가 명시되지 않아 분쟁 가능성이 높습니다.',
        severity: 3,
        isLegalBasis: true,
      ),
      Issue(
        clause: '임대인 동의 없는 전대차 허용',
        reason: '임대인 동의 없이 제3자에게 전대가 가능하다는 조항은 법적 효력이 없습니다.',
        severity: 2,
        isLegalBasis: true,
      ),
      Issue(
        clause: '수리비 전액 임차인 부담',
        reason: '구조적 하자 포함 모든 수리를 임차인이 부담하도록 되어 있어 불공정 조항에 해당합니다.',
        severity: 3,
        isLegalBasis: false,
      ),
    ],
    actionGuide: [
      ActionGuide(type: 'stop', message: '즉시 계약 체결을 중단하고 전문가와 상담하세요.'),
    ],
    publicData: PublicData(
      jeonseRatio: '118%',
      isRegistered: false,
      mortgageAmount: 280000000,
    ),
    mappingTablePurged: false,
  );
}
