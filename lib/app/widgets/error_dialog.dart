import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';

class ErrorDialog {
  ErrorDialog._();

  static const _retryableCodes = {
    'PUBLIC_API_ERROR',
    'AI_MODULE_ERROR',
    'SERVER_ERROR',
    'NETWORK_ERROR',
    'TIMEOUT_ERROR',
  };

  static const _infoCodes = {
    'REGION_NOT_FOUND',
  };

  static const _messages = {
    'INVALID_IMAGE': '지원하지 않는 이미지 형식이에요.\n다른 사진을 선택해주세요.',
    'OCR_FAILED': '계약서 텍스트를 추출하지 못했어요.\n더 선명한 사진으로 다시 시도해주세요.',
    'INVALID_SESSION': '세션이 만료되었어요.\n처음부터 다시 시도해주세요.',
    'ADDRESS_NOT_FOUND': '계약서의 주소 정보를 찾을 수 없어요.\n사진을 다시 확인해주세요.',
    'PUBLIC_API_ERROR': '공공 데이터 서비스가\n일시적으로 불안정해요.\n잠시 후 다시 시도해주세요.',
    'BUILDING_NOT_FOUND': '건물 정보를 찾을 수 없어요.\n사진을 다시 확인해주세요.',
    'PREREQUISITE_FAILED': '이전 단계가 완료되지 않았어요.\n처음부터 다시 시도해주세요.',
    'AI_MODULE_ERROR': 'AI 분석 중 일시적 오류가 발생했어요.\n잠시 후 다시 시도해주세요.',
    'REGION_NOT_FOUND': '해당 지역의 자립지원 기관 정보가 없어요.',
    'SERVER_ERROR': '일시적인 오류가 발생했어요.\n잠시 후 다시 시도해주세요.',
    'NETWORK_ERROR': '인터넷 연결을 확인해주세요.',
    'TIMEOUT_ERROR': '응답이 늦어지고 있어요.\n잠시 후 다시 시도해주세요.',
  };

  static void show({
    required String errorCode,
    VoidCallback? onRetry,
  }) {
    final message = _messages[errorCode] ?? '알 수 없는 오류가 발생했어요.\n잠시 후 다시 시도해주세요.';

    if (_infoCodes.contains(errorCode)) {
      _showInfo(message);
    } else if (_retryableCodes.contains(errorCode)) {
      _showTypeA(message, onRetry);
    } else {
      _showTypeB(message);
    }
  }

  static void _showTypeA(String message, VoidCallback? onRetry) {
    Get.dialog(
      _ErrorDialogWidget(
        message: message,
        isTypeA: true,
        onRetry: onRetry,
      ),
      barrierDismissible: false,
    );
  }

  static void _showTypeB(String message) {
    Get.dialog(
      _ErrorDialogWidget(
        message: message,
        isTypeA: false,
      ),
      barrierDismissible: false,
    );
  }

  static void _showInfo(String message) {
    Get.dialog(
      _ErrorDialogWidget(
        message: message,
        isInfo: true,
      ),
      barrierDismissible: true,
    );
  }
}

class _ErrorDialogWidget extends StatelessWidget {
  final String message;
  final bool isTypeA;
  final bool isInfo;
  final VoidCallback? onRetry;

  const _ErrorDialogWidget({
    required this.message,
    this.isTypeA = false,
    this.isInfo = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFFC107),
              size: 52,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6D3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isInfo)
              _dialogButton(label: '확인', onPressed: () => Get.back())
            else if (isTypeA)
              Row(
                children: [
                  Expanded(
                    child: _dialogButton(
                      label: '처음으로',
                      onPressed: () => Get.offNamedUntil(
                        Routes.analyzing,
                        (route) =>
                            route.settings.name == Routes.home || route.isFirst,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dialogButton(
                      label: '다시 시도',
                      icon: Icons.refresh,
                      onPressed: () {
                        Get.back();
                        onRetry?.call();
                      },
                    ),
                  ),
                ],
              )
            else
              _dialogButton(
                label: '다시 시작',
                onPressed: () => Get.offNamedUntil(
                  Routes.analyzing,
                  (route) =>
                      route.settings.name == Routes.home || route.isFirst,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dialogButton({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderLine),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 16, color: AppColors.textBlack),
          ],
        ],
      ),
    );
  }
}
