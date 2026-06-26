import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../../../data/models/risk_analysis_response.dart';
import '../controllers/result_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: controller.onBackPressed,
          icon: const Icon(Icons.chevron_left, color: AppColors.textBlack, size: 28),
        ),
        title: const Text(
          '분석 결과',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: _buildBottomSection(),
    );
  }

  // loading: skeleton, revealing/ready: 동일 key → AnimatedSwitcher 전환 없음
  Widget _buildBody() {
    if (controller.displayState.value == ResultDisplayState.loading) {
      return const _SkeletonBody(key: ValueKey('skeleton'));
    }
    return _ResultBody(key: const ValueKey('result'), controller: controller);
  }

  Widget _buildBottomSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderLine)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.menu_rounded,
            label: '기록',
            onTap: controller.onHistoryPressed,
          ),
          _BottomNavItem(
            icon: Icons.camera_alt_outlined,
            label: '분석',
            isActive: true,
            onTap: controller.onScanPressed,
          ),
          _BottomNavItem(
            icon: Icons.person_outline,
            label: '상담',
            onTap: controller.onHelpSupportPressed,
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryBlue : AppColors.textDisable;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 스켈레톤 전체 레이아웃 ─────────────────────────────────────
class _SkeletonBody extends StatelessWidget {
  const _SkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          const _SkeletonScoreCard(),
          const SizedBox(height: 16),
          _SkeletonPlaceholderCard(height: 160),
          const SizedBox(height: 16),
          _SkeletonPlaceholderCard(height: 140),
          const SizedBox(height: 16),
          _SkeletonPlaceholderCard(height: 140),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── 스켈레톤 박스 — Pulse 루프 애니메이션 ─────────────────────
// GetX Controller 미사용 순수 UI 컴포넌트이므로 StatefulWidget 허용 (Rule 16 예외)
class _SkeletonBox extends StatefulWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const _SkeletonBox({
    required this.height,
    this.width,
    this.borderRadius = 6,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, _) => Container(
        height: widget.height,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _opacity.value),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

// ── 스켈레톤 점수 카드 (실제 _ScoreCard 레이아웃 구조 반영) ────
class _SkeletonScoreCard extends StatelessWidget {
  const _SkeletonScoreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFCFCFCF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SkeletonBox(height: 16, width: 72),
              const _SkeletonBox(height: 26, width: 52, borderRadius: 13),
            ],
          ),
          const SizedBox(height: 12),
          const _SkeletonBox(height: 52, width: 120),
          const SizedBox(height: 20),
          const _SkeletonBox(height: 12),
          const SizedBox(height: 6),
          const _SkeletonBox(height: 20),
          const SizedBox(height: 16),
          const _SkeletonBox(height: 18, width: 200),
        ],
      ),
    );
  }
}

// ── 스켈레톤 일반 카드 ─────────────────────────────────────────
class _SkeletonPlaceholderCard extends StatelessWidget {
  final double height;

  const _SkeletonPlaceholderCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFCFCFCF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonBox(height: 16, width: 140),
          const SizedBox(height: 12),
          const _SkeletonBox(height: 12),
          const SizedBox(height: 8),
          const _SkeletonBox(height: 12, width: 220),
          const SizedBox(height: 8),
          const _SkeletonBox(height: 12, width: 180),
        ],
      ),
    );
  }
}

// ── 결과 전체 레이아웃 ─────────────────────────────────────────
class _ResultBody extends StatelessWidget {
  final ResultController controller;

  const _ResultBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          _ScoreCard(controller: controller),
          const SizedBox(height: 16),
          _IssuesCard(controller: controller),
          const SizedBox(height: 16),
          _LegalGuideCard(controller: controller),
          const SizedBox(height: 16),
          _GeneralGuideCard(controller: controller),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── 점수 카드 ─────────────────────────────────────────────────
class _ScoreCard extends StatelessWidget {
  final ResultController controller;

  const _ScoreCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: controller.levelColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '종합 점수',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.levelLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                controller.scoreText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                '/100',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _GaugeBar(score: controller.result.score),
          const SizedBox(height: 16),
          Text(
            controller.levelMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 게이지 바 ─────────────────────────────────────────────────
class _GaugeBar extends StatelessWidget {
  final int score;

  const _GaugeBar({required this.score});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final arrowX = ((score / 100) * w).clamp(0.0, w - 20.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  Flexible(
                    flex: 30,
                    child: Container(height: 12, color: const Color(0xFFFF3826)),
                  ),
                  Flexible(
                    flex: 35,
                    child: Container(height: 12, color: AppColors.caution),
                  ),
                  Flexible(
                    flex: 35,
                    child: Container(height: 12, color: const Color(0xFF66BB6A)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: w,
              height: 20,
              child: Stack(
                children: [
                  Positioned(
                    left: arrowX,
                    child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: w,
              height: 16,
              child: Stack(
                children: [
                  Positioned(
                    left: w * 0.30 - 8,
                    child: const Text('30', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                  Positioned(
                    left: w * 0.65 - 8,
                    child: const Text('65', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                  Positioned(
                    right: 0,
                    child: const Text('100', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── 확인된 문제 카드 ─────────────────────────────────────────
class _IssuesCard extends StatelessWidget {
  final ResultController controller;

  const _IssuesCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB0B0B0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '확인된 문제 (${controller.issueCount}건)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          if (controller.issueCount == 0)
            Text(
              controller.issueMessage,
              style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            )
          else
            ...controller.issues.map((issue) => _IssueRow(issue: issue)),
        ],
      ),
    );
  }
}

class _IssueRow extends StatelessWidget {
  final Issue issue;

  const _IssueRow({required this.issue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(Icons.circle, color: Colors.white70, size: 6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.clause,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  issue.reason,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 가이드 카드 1: 강행규정 위반 ──────────────────────────────
class _LegalGuideCard extends StatelessWidget {
  final ResultController controller;

  const _LegalGuideCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.legalGuideTitleText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            controller.legalGuideBodyText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          if (!controller.hasLegalIssues)
            const Text(
              '해당 없음',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            )
          else ...[
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),
            ...controller.legalIssues.map((issue) => _IssueRow(issue: issue)),
          ],
        ],
      ),
    );
  }
}

// ── 가이드 카드 2: 일반 위험 ─────────────────────────────────
class _GeneralGuideCard extends StatelessWidget {
  final ResultController controller;

  const _GeneralGuideCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB0B0B0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.generalGuideTitleText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            controller.generalGuideBodyText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          if (!controller.hasGeneralIssues)
            const Text(
              '해당 없음',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            )
          else ...[
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),
            ...controller.generalIssues.map((issue) => _IssueRow(issue: issue)),
          ],
        ],
      ),
    );
  }
}
