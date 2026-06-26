import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';

/// 앱 공통 하단 네비게이션 바.
///
/// 화면마다 하단바를 따로 만들지 말고 이 위젯 하나를 갖다 쓰세요.
/// 현재 화면에 해당하는 탭을 [current]로 넘기면 그 탭이 강조됩니다.
/// (해당하는 탭이 없는 화면은 [AppNavTab.none] — 기본값)
///
/// 사용 예:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: const AppBottomNav(current: AppNavTab.history),
/// )
/// ```
enum AppNavTab { history, analyze, consult, none }

class AppBottomNav extends StatelessWidget {
  final AppNavTab current;

  const AppBottomNav({super.key, this.current = AppNavTab.none});

  // 간단한 네비게이션은 위젯에서 직접 처리 (Rule 9)
  void _onTap(AppNavTab tab) {
    if (tab == current) return; // 이미 그 화면이면 이동 안 함
    switch (tab) {
      case AppNavTab.history:
        Get.toNamed(Routes.history);
      case AppNavTab.analyze:
        Get.toNamed(Routes.analyzing); // ★ 카메라 직행이 아니라 분석화면으로
      case AppNavTab.consult:
        Get.toNamed(Routes.helpSupport); // 피해 상담 화면
      case AppNavTab.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderLine)),
      ),
      // ★ 시스템 제스처 바와 겹치지 않도록 SafeArea (top 제외)
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.segment,
                label: '기록',
                isActive: current == AppNavTab.history,
                onTap: () => _onTap(AppNavTab.history),
              ),
              _NavItem(
                icon: Icons.photo_camera_outlined,
                label: '분석',
                isActive: current == AppNavTab.analyze,
                onTap: () => _onTap(AppNavTab.analyze),
              ),
              _NavItem(
                icon: Icons.support_agent_outlined,
                label: '상담',
                isActive: current == AppNavTab.consult,
                onTap: () => _onTap(AppNavTab.consult),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryBlue : AppColors.textDisable;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
      ),
    );
  }
}
