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

  /// 계약서 한 건에 담을 수 있는 최대 이미지(페이지) 수.
  static const int maxImages = 10;

  final currentStep = 0.obs;
  final _isProcessing = false.obs;
  final recentHistory = <HistoryItem>[].obs;

  /// 분석 대기 중 선택된 이미지 경로들 (촬영·앨범으로 추가, 최대 [maxImages]장).
  final selectedImages = <String>[].obs;

  // 이 화면(컨트롤러)이 dispose 되었는지 여부.
  // 분석 중 사용자가 뒤로가기로 나가면 onClose()에서 true가 되고,
  // 그 뒤 백그라운드 분석이 끝나도 다이얼로그/화면이동을 막는다.
  bool _isClosed = false;

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
    if (args is Map && args['imagePath'] is String) {
      _addImage(args['imagePath'] as String);
    }
  }

  @override
  void onClose() {
    _isClosed = true; // 화면이 사라졌음을 표시 → 이후 다이얼로그/이동 차단
    _apiProvider.dispose();
    super.onClose();
  }

  Future<void> _loadRecentHistory() async {
    try {
      await _storageService.init();
      recentHistory.value = await _storageService.getHistory();
    } catch (_) {}
  }

  // ── 이미지 선택 (촬영/앨범) ─────────────────────────────
  bool get canAddMore => selectedImages.length < maxImages;
  bool get hasImages => selectedImages.isNotEmpty;
  String get selectedCountText => '${selectedImages.length}/$maxImages';
  String get analyzeButtonText =>
      hasImages ? '분석하기 (${selectedImages.length}장)' : '분석하기';

  /// 카메라로 촬영해 한 장 추가.
  Future<void> addFromCamera() async {
    if (!_ensureCanAdd()) return;
    final result = await Get.toNamed(Routes.scan);
    if (result is String) _addImage(result);
  }

  /// 앨범에서 여러 장 선택해 추가 (imageQuality: JPEG 재인코딩 + 압축).
  Future<void> addFromGallery() async {
    if (!_ensureCanAdd()) return;
    final files = await _picker.pickMultiImage(imageQuality: 90);
    for (final f in files) {
      if (!canAddMore) {
        _showMaxReached();
        break;
      }
      _addImage(f.path);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  void _addImage(String path) {
    if (!canAddMore) {
      _showMaxReached();
      return;
    }
    selectedImages.add(path);
  }

  bool _ensureCanAdd() {
    if (canAddMore) return true;
    _showMaxReached();
    return false;
  }

  void _showMaxReached() {
    Get.snackbar(
      '안내',
      '최대 $maxImages장까지 추가할 수 있어요.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  /// "분석하기" 버튼 → 선택된 이미지들로 분석 시작.
  void startAnalysis() {
    if (_isProcessing.value) return;
    if (selectedImages.isEmpty) {
      Get.snackbar(
        '안내',
        '먼저 계약서 이미지를 추가해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    _runAnalysis(selectedImages.toList());
  }

  void goToHistory() => Get.toNamed(Routes.history);

  /// 최근 기록 아이템을 누르면 그 분석 결과 화면으로 이동.
  /// (history_controller.onHistoryItemPressed 와 동일한 동작)
  void onRecentHistoryItemPressed(HistoryItem item) {
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

  /// 분석 중 뒤로가기를 눌렀을 때 호출 (PopScope 에서 사용).
  /// "나가면 분석이 중단됩니다" 확인 다이얼로그를 띄운다.
  Future<void> onWillPop() async {
    // 분석 중이 아니면 그냥 뒤로가기 허용
    if (!_isProcessing.value) {
      Get.back();
      return;
    }

    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '분석을 중단할까요?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: const Text(
          '나가면 계약서 분석이 중단됩니다.',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // 다이얼로그만 닫기 → 화면 유지
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              _cancelAnalysis(); // 분석 중단 표시
              Get.back(); // 분석 화면 나가기
            },
            child: const Text(
              '나가기',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// 진행 중인 분석을 "중단"으로 표시.
  /// http 요청 자체를 즉시 취소할 수는 없지만,
  /// _isClosed=true 로 두면 결과가 와도 다이얼로그/이동이 일어나지 않는다.
  void _cancelAnalysis() {
    _isClosed = true;
    _isProcessing.value = false;
  }

  Future<void> _runAnalysis(List<String> imagePaths) async {
    if (_isProcessing.value) return;
    _isProcessing.value = true;
    currentStep.value = 0;

    try {
      final imageResult = await _apiProvider.analyzeImage(imagePaths);

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

      // 화면이 이미 사라졌으면 결과 화면으로 이동하지 않는다.
      if (_isClosed) return;

      Get.offNamed(Routes.result, arguments: {
        'result': riskResult,
        'address': addressResult?.roadAddress ?? imageResult.address ?? '',
      });
    } on ApiException catch (e) {
      _showErrorIfAlive(
        errorCode: e.errorCode,
        imagePaths: imagePaths,
      );
    } on SocketException catch (e) {
      final msg = e.message.toLowerCase();
      final isNoInternet = msg.contains('network is unreachable') ||
          msg.contains('failed host lookup') ||
          msg.contains('no address associated') ||
          msg.contains('no route to host');
      _showErrorIfAlive(
        errorCode: isNoInternet ? 'NETWORK_ERROR' : 'SERVER_ERROR',
        imagePaths: imagePaths,
      );
    } on TimeoutException {
      _showErrorIfAlive(
        errorCode: 'TIMEOUT_ERROR',
        imagePaths: imagePaths,
      );
    } catch (_) {
      _showErrorIfAlive(
        errorCode: 'SERVER_ERROR',
        imagePaths: imagePaths,
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  /// 분석 화면이 아직 살아있을 때만 에러 다이얼로그를 띄운다.
  /// 사용자가 이미 나갔으면(_isClosed) 전역 다이얼로그가 뜨지 않도록 막는다.
  void _showErrorIfAlive({
    required String errorCode,
    required List<String> imagePaths,
  }) {
    if (_isClosed) return;
    ErrorDialog.show(
      errorCode: errorCode,
      onRetry: () => _runAnalysis(imagePaths),
    );
  }
}