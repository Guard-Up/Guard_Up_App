import 'package:get/get.dart';
import '../../../data/models/history_item.dart';
import '../../../data/models/risk_analysis_response.dart';
import '../../../routes/app_routes.dart';
import '../../../services/local_storage_service.dart';

class HistoryController extends GetxController {
  final _storageService = LocalStorageService();

  final historyList = <HistoryItem>[].obs;
  final isLoading = false.obs;

  bool get isEmpty => historyList.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    try {
      await _storageService.init();
      historyList.value = await _storageService.getHistory();
    } finally {
      isLoading.value = false;
    }
  }

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
    });
  }

  Future<void> deleteHistory(int id) async {
    await _storageService.deleteHistory(id);
    await loadHistory();
  }
}
