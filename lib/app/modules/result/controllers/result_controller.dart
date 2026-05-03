import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../../../data/models/history_item.dart';
import '../../../data/models/risk_analysis_response.dart';
import '../../../routes/app_routes.dart';
import '../../../services/local_storage_service.dart';

class ResultController extends GetxController {
  final _storageService = LocalStorageService();

  late final RiskAnalysisResponse result;
  late final String address;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map;
    result = args['result'] as RiskAnalysisResponse;
    address = args['address'] as String? ?? '';
    _saveToHistory();
  }

  Future<void> _saveToHistory() async {
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
  }

  // ViewModel getters
  String get scoreText => '${result.score}/100';
  String get levelLabel => result.level.label;
  String get levelMessage => result.level.message;
  bool get hasIssues => result.issues.isNotEmpty;
  int get issueCount => result.issues.length;

  Color get levelColor {
    switch (result.level) {
      case RiskLevel.safe:
        return AppColors.safe;
      case RiskLevel.caution:
        return AppColors.caution;
      case RiskLevel.danger:
        return AppColors.danger;
    }
  }

  void onBackPressed() => Get.offAllNamed(Routes.home);
  void onGuidePressed() => Get.toNamed(Routes.guide);
}
