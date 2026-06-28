import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/history_item.dart';
import '../../../routes/app_routes.dart';
import '../controllers/analyzing_controller.dart';

class AnalyzingView extends GetView<AnalyzingController> {
  const AnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    // 분석 중 뒤로가기를 가로채기 위해 PopScope 로 감싼다.
    // canPop: false 로 두고, 실제 처리는 controller.onWillPop 에서 한다.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // 이미 pop 되었으면 중복 처리 방지
        controller.onWillPop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          title: const Text(
            '계약서 분석',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          // 기본 뒤로가기 버튼도 PopScope 를 거치도록 직접 연결
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => controller.onWillPop(),
          ),
          actions: [
            IconButton(
              onPressed: () => Get.offAllNamed(Routes.home),
              icon: const Icon(Icons.home, color: Colors.black),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        // isProcessing 전환만 추적하는 외부 Obx
        body: Obx(() {
          if (controller.isProcessing) return _buildProcessingBody();
          return _buildIdleBody();
        }),
      ),
    );
  }

  // 분석 대기 화면 — isProcessing == false 일 때만 빌드됨
  Widget _buildIdleBody() {
    return Column(
      children: [
        _buildUploadSection(),
        // Expanded는 Column의 직계 자식이어야 함 → Obx를 Expanded 내부에 배치
        // hasRecentHistory 변경 시 이 Obx만 리빌드
        Expanded(
          child: Obx(() {
            if (!controller.hasRecentHistory) return const SizedBox.shrink();
            return _buildRecentHistory();
          }),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '계약서를 사진 찍거나\n파일에서 업로드 해주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: controller.openCamera,
              child: const Icon(
                Icons.camera_alt,
                size: 56,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.uploadFile,
              icon: const Icon(Icons.upload, size: 18),
              label: const Text(
                '파일 업로드',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B8CFF),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentHistory() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 기록',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: controller.goToHistory,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: controller.recentHistory.length,
              separatorBuilder: (_, _) => const SizedBox(height: 24),
              itemBuilder: (_, index) =>
                  _buildHistoryItem(controller.recentHistory[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    // 아이템 전체를 눌러도 결과 화면으로 이동 (더보기 외에 아이템 클릭도 지원)
    return InkWell(
      onTap: () => controller.onRecentHistoryItemPressed(item),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              controller.recentHistoryItemIcon(item),
              color: Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.address,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: controller.recentHistoryItemColor(item),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                controller.recentHistoryItemBadge(item),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 분석 진행 화면 — currentStep은 내부 Obx만 추적, 외부 Obx 리빌드 없음
  Widget _buildProcessingBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF8B8CFF)),
            const SizedBox(height: 32),
            // currentMessage 변경 시 이 Obx만 리빌드
            Obx(() => Text(
                  controller.currentMessage,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 24),
            // currentStep 변경 시 이 Obx만 리빌드
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Controller getter로 비즈니스 로직 위임 (Rule 2)
                        color: controller.isStepActive(index)
                            ? const Color(0xFF8B8CFF)
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                )),
          ],
        ),
      ),
    );
  }
}