import 'package:get/get.dart';
import '../../../data/models/verify_address_response.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';

class AnalyzingController extends GetxController {
  final _apiProvider = ApiProvider();

  final currentStep = 0.obs;
  final hasError = false.obs;

  final List<String> stepMessages = [
    '계약서를 분석하는 중.',
    '독소 조항을 검토하는 중..',
    '리스크 점수를 산출하는 중...',
  ];

  String get currentMessage => stepMessages[currentStep.value.clamp(0, 2)];

  @override
  void onInit() {
    super.onInit();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    final args = Get.arguments;
    if (args is! Map || args['base64Image'] == null) {
      hasError.value = true;
      return;
    }
    final base64Image = args['base64Image'] as String;

    try {
      // 1단계: 이미지 분석
      currentStep.value = 0;
      final imageResult = await _apiProvider.analyzeImage(base64Image);

      // 2단계: 주소 검증
      currentStep.value = 1;
      VerifyAddressResponse? addressResult;
      if (imageResult.address != null) {
        addressResult = await _apiProvider.verifyAddress(
            imageResult.sessionId, imageResult.address!);
      }

      // 3단계: 건물 정보 (세션에 데이터 축적용, 결과는 4단계에서 통합됨)
      if (addressResult?.roadAddress != null) {
        await _apiProvider.getBuilding(
            imageResult.sessionId, addressResult!.roadAddress!);
      }

      // 4단계: AI 리스크 분석
      currentStep.value = 2;
      final riskResult = await _apiProvider.analyzeRisk(imageResult.sessionId);

      Get.offNamed(Routes.result, arguments: {
        'result': riskResult,
        'address': addressResult?.roadAddress ?? imageResult.address ?? '',
      });
    } on ApiException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    }
  }

  void onRetryPressed() => Get.offAllNamed(Routes.scan);
}
