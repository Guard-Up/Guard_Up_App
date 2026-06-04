import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/history_item.dart';
import '../../../data/models/risk_analysis_response.dart';
import '../../../routes/app_routes.dart';
import '../../../services/local_storage_service.dart';

class HistoryController extends GetxController {
  final _storageService = Get.find<LocalStorageService>();

  final historyList = <HistoryItem>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  bool get isEmpty => historyList.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      await _storageService.init();
      historyList.value = await _storageService.getHistory();
    } catch (e, st) {
      log('히스토리 로드 실패', name: 'HistoryController', error: e, stackTrace: st);
      historyList.value = [];
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  // ViewModel helpers
  String itemDateText(HistoryItem item) =>
      '${item.createdAt.year}.'
      '${item.createdAt.month.toString().padLeft(2, '0')}.'
      '${item.createdAt.day.toString().padLeft(2, '0')}';

  Color itemLevelColor(HistoryItem item) => item.level.color;

  String itemLevelLabel(HistoryItem item) => item.level.label;

  void onHistoryItemPressed(HistoryItem item) {
    Get.toNamed(Routes.result, arguments: {
      'result': RiskAnalysisResponse(
        score: item.score,
        level: item.level,
        issues: item.issues,
        actionGuide: item.actionGuide,
        publicData: item.publicData,
        mappingTablePurged: true,
      ),
      'address': item.address,
      'fromHistory': true,
    });
  }

  Future<void> deleteHistory(int id) async {
    await _storageService.deleteHistory(id);
    await loadHistory();
  }

}
