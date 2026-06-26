import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/guide_controller.dart';

class GuideView extends GetView<GuideController> {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '도움말 & 가이드',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentHorizontal,
          vertical: 16,
        ),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AccordionSection(
                  icon: '⚠️',
                  title: '분석 서비스 한계 안내',
                  isExpanded: controller.isSectionExpanded(0),
                  onTap: () => controller.onSectionPressed(0),
                  child: const _LimitationContent(),
                ),
                const SizedBox(height: 12),
                _AccordionSection(
                  icon: '📋',
                  title: '계약 체크리스트',
                  isExpanded: controller.isSectionExpanded(1),
                  onTap: () => controller.onSectionPressed(1),
                  child: const _ChecklistContent(),
                ),
                const SizedBox(height: 12),
                _AccordionSection(
                  icon: '💡',
                  title: '알아두면 좋은 정보',
                  isExpanded: controller.isSectionExpanded(2),
                  onTap: () => controller.onSectionPressed(2),
                  child: const _FaqContent(),
                ),
              ],
            )),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

class _AccordionSection extends StatelessWidget {
  final String icon;
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget child;

  const _AccordionSection({
    required this.icon,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isExpanded ? AppColors.white : AppColors.surfaceDefault,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? AppColors.borderLine : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isExpanded ? FontWeight.w700 : FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textBlack,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const _DashedDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: child,
            ),
          ],
        ],
      ),
    );
  }
}

class _LimitationContent extends StatelessWidget {
  const _LimitationContent();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuideController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...controller.limitations.map(
          (item) => _LimitationTile(
            title: item.title,
            onTap: () => controller.onLimitationPressed(item),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          GuideController.limitationFooter,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textDisable,
          ),
        ),
      ],
    );
  }
}

class _LimitationTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _LimitationTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Text('• ', style: TextStyle(fontSize: 13)),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textBlack,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textSub,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistContent extends StatelessWidget {
  const _ChecklistContent();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuideController>();

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: ChecklistStage.values.map((stage) {
                final isSelected = controller.selectedStage.value == stage;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _StageChip(
                    label: stage.label,
                    isSelected: isSelected,
                    onTap: () => controller.onStagePressed(stage),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3D6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(controller.checklistItems.length,
                    (index) {
                  final stage = controller.selectedStage.value;
                  return _ChecklistRow(
                    text: controller.checklistItems[index],
                    isChecked: controller.isChecked(stage, index),
                    onTap: () =>
                        controller.onChecklistItemToggled(stage, index),
                  );
                }),
              ),
            ),
          ],
        ));
  }
}

class _ChecklistRow extends StatelessWidget {
  final String text;
  final bool isChecked;
  final VoidCallback onTap;

  const _ChecklistRow({
    required this.text,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isChecked
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 18,
              color: isChecked ? AppColors.primaryBlue : AppColors.textSub,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: isChecked ? AppColors.textSub : AppColors.textBlack,
                  decoration:
                      isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StageChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? const Color(0xFFFFA94D) : const Color(0xFF7DC97D);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FaqContent extends StatelessWidget {
  const _FaqContent();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuideController>();
    return Column(
      children: List.generate(controller.faqs.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: InkWell(
            onTap: () => controller.onFaqPressed(index),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceDefault,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Q. ${controller.faqs[index].question}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 4.0;
          const dashSpace = 3.0;
          final dashCount =
              (constraints.maxWidth / (dashWidth + dashSpace)).floor();
          return SizedBox(
            height: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                dashCount,
                (_) => const SizedBox(
                  width: dashWidth,
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.borderDash),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

