import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../controllers/independence_support_controller.dart';

class IndependenceSupportView extends GetView<IndependenceSupportController> {
  const IndependenceSupportView({super.key});

  // 시안에 맞춘 박스 색상
  static const _cardColor = Color(0xFFEFEFEF); // 섹션 카드 (연회색)
  static const _resultColor = Color(0xFFBDBDBD); // 결과 박스 (중간 회색)
  static const _loadingColor = Color(0xFF8A8A8A); // 로딩 박스 (진회색)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // ── 상단바 ──
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: AppSpacing.contentHorizontal,
        title: Row(
          children: [
            Image.asset('assets/images/shield.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text(
              '안심 계약 가디언',
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.textBlack, size: 28),
            tooltip: '홈',
            onPressed: controller.onHomePressed,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentHorizontal,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConsultCard(),
            const SizedBox(height: 24),
            _buildDashedDivider(),
            const SizedBox(height: 24),
            _buildProOrgCard(),
          ],
        ),
      ),
      // ── 하단 네비게이션: 기록 / 촬영 / 사용자 ──
      bottomNavigationBar: _BottomNav(controller: controller),
    );
  }

  // ── 자립 상담 카드 ──────────────────────────────────────
  Widget _buildConsultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '자립을 준비하는 청년인가요?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '자립 지원 전담 기관과 상담해보세요.',
            style: TextStyle(fontSize: 12, color: AppColors.textSub),
          ),
          const SizedBox(height: 16),
          _buildSearchRow(),
          // 결과 영역 (로딩 / 기관 목록 / 추가 예정 안내)
          Obx(() {
            // 1) 로딩 중
            if (controller.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _loadingBox(),
              );
            }
            // 2) 조회 결과가 있으면 기관 목록
            if (controller.results.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: controller.results
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _resultBox(e),
                        ),
                      )
                      .toList(),
                ),
              );
            }
            // 3) 조회는 했지만 데이터가 없으면 "추가 예정" 안내
            if (controller.hasSearched.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _noticeBox(controller.searchedCity.value ?? ''),
              );
            }
            // 4) 아직 조회 전 → 아무것도 안 보임
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // ── 시 선택 + 조회 줄 ───────────────────────────────────
  Widget _buildSearchRow() {
    return Row(
      children: [
        // 시 선택 (MenuAnchor: 목록이 칸 바로 아래에 좁게 떨어짐 → 화면 안 가림)
        MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.white),
            maximumSize:
                WidgetStateProperty.all(const Size.fromHeight(300)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.borderLine),
              ),
            ),
          ),
          menuChildren: controller.cities
              .map(
                (c) => SizedBox(
                  width: 120,
                  child: MenuItemButton(
                    onPressed: () => controller.selectedCity.value = c,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          builder: (context, menuController, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => menuController.isOpen
                  ? menuController.close()
                  : menuController.open(),
              child: Container(
                width: 120,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.borderLine),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.selectedCity.value ?? '선택',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: controller.selectedCity.value == null
                                ? AppColors.textDisable
                                : AppColors.textBlack,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 22),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        const Text(
          '시',
          style: TextStyle(fontSize: 16, color: AppColors.textBlack),
        ),
        const Spacer(),
        // 조회 버튼 (시안: 흰 배경 + 테두리 + "조회 🔍")
        OutlinedButton(
          onPressed: controller.onSearch,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textBlack,
            side: const BorderSide(color: AppColors.borderLine),
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '조회',
                style: TextStyle(fontSize: 14, color: AppColors.textBlack),
              ),
              SizedBox(width: 4),
              Icon(Icons.search, size: 16, color: AppColors.textSub),
            ],
          ),
        ),
      ],
    );
  }

  // ── 로딩 박스  ─────
  Widget _loadingBox() {
    return Center(
      child: Container(
        width: 200,
        height: 110,
        decoration: BoxDecoration(
          color: _loadingColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
  }

  // ── "추가 예정" 안내 박스 ───────────────────────────────
  Widget _noticeBox(String city) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _resultColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$city의 자립 상담 기관은 추가 예정입니다.',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textBlack,
          height: 1.5,
        ),
      ),
    );
  }

  // ── 결과 박스  ──
  Widget _resultBox(SupportOrg org) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _resultColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '주소 : ${org.address}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textBlack,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '웹사이트 : ${org.websiteLabel} - ',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textBlack,
                ),
              ),
              GestureDetector(
                onTap: () => controller.copyWebsite(org.websiteUrl),
                child: const Text(
                  '바로가기',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                '전화번호 : ',
                style: TextStyle(fontSize: 13, color: AppColors.textBlack),
              ),
              GestureDetector(
                onTap: () => controller.callNumber(org.phone),
                child: Text(
                  org.phone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 점선 구분선 ─────────────────────────────────────────
  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashW = 6.0, gap = 4.0;
        final count = (constraints.maxWidth / (dashW + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashW,
              height: 1.5,
              color: AppColors.borderDash,
            ),
          ),
        );
      },
    );
  }

  // ── 전문 상담 기관 카드 (고정 내용) ─────────────────────
  Widget _buildProOrgCard() {
    const orgs = [
      ['소비자보호원', '1372', ''],
      ['주거복지재단', '1600-0777', ''],
      ['대한법률구조공단', '132', '(무료 법률 상담)'],
      ['대한변호사협회 법률구조재단', '02-3476-6515', ''],
      ['법률홈닥터', '132', '(주거 관련 무료 법률 상담)'],
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전문 상담 기관',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 14),
          ...orgs.map(
            (o) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 5, color: AppColors.textBlack),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          o[0],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.phone, size: 15, color: AppColors.danger),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => controller.callNumber(o[1]),
                          child: Text(
                            o[1],
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        if (o[2].isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Text(
                            o[2],
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSub,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 하단 네비게이션 바 ────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final IndependenceSupportController controller;
  const _BottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderLine)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.segment, size: 28, color: AppColors.textBlack),
                tooltip: '최근 기록',
                onPressed: controller.onHistoryPressed,
              ),
              IconButton(
                icon: const Icon(Icons.photo_camera_outlined, size: 30, color: AppColors.textBlack),
                tooltip: '계약서 촬영',
                onPressed: controller.onScanPressed,
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, size: 28, color: AppColors.primaryBlue),
                tooltip: '사용자',
                onPressed: controller.onUserPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}