import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
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
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentHorizontal,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '안녕하세요!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '계약 전 꼭 확인하세요 👋',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSub,
              ),
            ),
            const SizedBox(height: 20),
            _PrimaryCard(onTap: controller.onScanPressed),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
              children: [
                _MenuCard(
                  icon: Icons.search_rounded,
                  title: '최근 기록',
                  subtitle: '분석 결과\n확인하기',
                  onTap: controller.onHistoryPressed,
                ),
                _MenuCard(
                  icon: Icons.help_outline_rounded,
                  title: '도움말&가이드',
                  subtitle: '서비스 안내\n확인하기',
                  onTap: controller.onGuidePressed,
                ),
                _MenuCard(
                  icon: Icons.phone_outlined,
                  title: '피해 상담',
                  subtitle: '전문 기관에\n상담 받기',
                  onTap: controller.onHelpsupportPressed,
                ),
                _MenuCard(
                  icon: Icons.accessibility_new,
                  title: '자립 지원 상담',
                  subtitle: '지원 기관\n연결하기',
                  onTap: controller.onIndependenceSupportPressed,
                ),
              ],
            ),
          ],
        ),
      ),
      // 공통 하단바 사용 (모든 화면 위치/SafeArea 통일)
      bottomNavigationBar: const AppBottomNav(current: AppNavTab.analyze),
    );
  }
}

class _PrimaryCard extends StatelessWidget {
  final VoidCallback onTap;

  const _PrimaryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.document_scanner_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '계약서 분석',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '계약서 사진을 찍어\nAI가 분석해드려요',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 28),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSub,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}