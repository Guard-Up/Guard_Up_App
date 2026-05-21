import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../controllers/guide_qna_controller.dart';

class GuideQnaView extends GetView<GuideQnaController> {
  const GuideQnaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Q&A',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentHorizontal,
          vertical: 16,
        ),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDefault,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q. ${controller.current.question}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    controller.current.answer,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const Spacer(),
                _PaginationBar(),
              ],
            )),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuideQnaController>();
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              label: '<이전',
              enabled: controller.canGoPrev,
              onTap: controller.onPrevPressed,
            ),
            Text(
              controller.pageText,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSub,
              ),
            ),
            _NavButton(
              label: '다음>',
              enabled: controller.canGoNext,
              onTap: controller.onNextPressed,
            ),
          ],
        ));
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceDefault,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: enabled ? AppColors.textBlack : AppColors.textDisable,
          ),
        ),
      ),
    );
  }
}
