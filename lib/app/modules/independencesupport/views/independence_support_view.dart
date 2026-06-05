import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../controllers/independence_support_controller.dart';

class IndependenceSupportView extends GetView<IndependenceSupportController> {
  const IndependenceSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textBlack, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '자립 지원',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(
          child: Text(
            '자립 지원',
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: 15,
            ),
          ),
        );
      }),
    );
  }
}
