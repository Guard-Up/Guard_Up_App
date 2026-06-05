import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../../guide/controllers/guide_controller.dart';
import '../controllers/guide_detail_controller.dart';

class GuideDetailView extends GetView<GuideDetailController> {
  const GuideDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.item.title,
          style: const TextStyle(
            color: AppColors.textBlack,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentHorizontal,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceDefault,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                controller.item.body,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: AppColors.textBlack,
                ),
              ),
            ),
            if (controller.item.links.isNotEmpty) ...[
              const SizedBox(height: 20),
              ...controller.item.links.map(
                (link) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _LinkButton(
                    label: link.label,
                    icon: link.type == LimitationLinkType.tel
                        ? Icons.phone_outlined
                        : Icons.open_in_new,
                    onTap: () => controller.onLinkPressed(link),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              GuideController.limitationFooter,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textDisable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _LinkButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.primaryBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
