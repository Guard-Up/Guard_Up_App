import 'dart:io';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 선택된 이미지가 있으면 썸네일, 없으면 안내 박스
          Obx(() => controller.hasImages
              ? _buildThumbnailStrip()
              : _buildEmptyHint()),
          const SizedBox(height: 16),
          // 촬영 / 앨범 추가 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.addFromCamera,
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text('촬영'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.addFromGallery,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text('앨범'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 분석하기 버튼 (이미지 있을 때만 활성)
          Obx(() => ElevatedButton(
                onPressed:
                    controller.hasImages ? controller.startAnalysis : null,
                child: Text(controller.analyzeButtonText),
              )),
        ],
      ),
    );
  }

  // 이미지 미선택 안내 박스
  Widget _buildEmptyHint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 48, color: Colors.black45),
          SizedBox(height: 12),
          Text(
            '계약서를 촬영하거나 앨범에서 선택하세요\n여러 장(페이지)도 함께 분석돼요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 선택된 이미지 썸네일 가로 스트립 (각 삭제 가능)
  Widget _buildThumbnailStrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '선택된 계약서',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              controller.selectedCountText,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.selectedImages.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, index) => _buildThumbnail(
              controller.selectedImages[index],
              index,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(String path, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(path),
            width: 74,
            height: 96,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => controller.removeImage(index),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
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