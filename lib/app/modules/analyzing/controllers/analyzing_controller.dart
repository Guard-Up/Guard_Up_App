import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/history_item.dart';
import '../../../data/models/risk_analysis_response.dart';
import '../../../data/models/verify_address_response.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/local_storage_service.dart';
import '../../../widgets/error_dialog.dart';

class AnalyzingController extends GetxController {
  final _apiProvider = ApiProvider();
  final _picker = ImagePicker();
  final _storageService = Get.find<LocalStorageService>();

  final currentStep = 0.obs;
  final _isProcessing = false.obs;
  final recentHistory = <HistoryItem>[].obs;

  bool get isProcessing => _isProcessing.value;

  final List<String> stepMessages = [
    '계약서를 분석하는 중.',
    '독소 조항을 검토하는 중..',
    '리스크 점수를 산출하는 중...',
  ];

  String get currentMessage => stepMessages[currentStep.value.clamp(0, 2)];

  bool get hasRecentHistory => recentHistory.isNotEmpty;

  bool isStepActive(int index) => index <= currentStep.value;

  // ViewModel helpers for recent history items
  IconData recentHistoryItemIcon(HistoryItem item) =>
      item.level == RiskLevel.danger ? Icons.home : Icons.shield;

  Color recentHistoryItemColor(HistoryItem item) => item.level.color;

  String recentHistoryItemBadge(HistoryItem item) =>
      '${item.level.label} ${item.score}';

  @override
  void onInit() {
    super.onInit();
    _loadRecentHistory();
    final args = Get.arguments;
    if (args is Map && args['imagePath'] != null) {
      _runAnalysis(args['imagePath'] as String);
    }
  }

  @override
  void onClose() {
    _apiProvider.dispose();
    super.onClose();
  }

  Future<void> _loadRecentHistory() async {
    try {
      await _storageService.init();
      recentHistory.value = await _storageService.getHistory();
    } catch (_) {}
  }

  Future<void> openCamera() async {
    final result = await Get.toNamed(Routes.scan);
    if (result is String) _runAnalysis(result);
  }

  Future<void> uploadFile() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    _runAnalysis(file.path);
  }

  void goToHistory() => Get.toNamed(Routes.history);

  Future<void> _runAnalysis(String imagePath) async {
    if (_isProcessing.value) return;
    _isProcessing.value = true;
    currentStep.value = 0;

    try {
      final imageResult = await _apiProvider.analyzeImage(imagePath);

      currentStep.value = 1;
      VerifyAddressResponse? addressResult;
      if (imageResult.address != null) {
        addressResult = await _apiProvider.verifyAddress(
          imageResult.sessionId,
          imageResult.address!,
        );
      }

      if (addressResult?.roadAddress != null) {
        await _apiProvider.getBuilding(
          imageResult.sessionId,
          addressResult!.roadAddress!,
        );
      }

      currentStep.value = 2;
      final riskResult = await _apiProvider.analyzeRisk(imageResult.sessionId);

      Get.offNamed(Routes.result, arguments: {
        'result': riskResult,
        'address': addressResult?.roadAddress ?? imageResult.address ?? '',
      });
    } on ApiException catch (e) {
      ErrorDialog.show(
        errorCode: e.errorCode,
        onRetry: () => _runAnalysis(imagePath),
      );
    } on SocketException catch (e) {
      final msg = e.message.toLowerCase();
      final isNoInternet = msg.contains('network is unreachable') ||
          msg.contains('failed host lookup') ||
          msg.contains('no address associated') ||
          msg.contains('no route to host');
      ErrorDialog.show(
        errorCode: isNoInternet ? 'NETWORK_ERROR' : 'SERVER_ERROR',
        onRetry: () => _runAnalysis(imagePath),
      );
    } on TimeoutException {
      ErrorDialog.show(
        errorCode: 'TIMEOUT_ERROR',
        onRetry: () => _runAnalysis(imagePath),
      );
    } catch (_) {
      ErrorDialog.show(
        errorCode: 'SERVER_ERROR',
        onRetry: () => _runAnalysis(imagePath),
      );
    } finally {
      _isProcessing.value = false;
    }
  }
}
