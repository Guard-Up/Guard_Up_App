import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _SplashBody(controller: controller),
    );
  }
}

// Rule 16 예외: 순수 UI 애니메이션 전담 컴포넌트 (GetX Controller 미사용)
class _SplashBody extends StatefulWidget {
  final SplashController controller;

  const _SplashBody({required this.controller});

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _pulseCtrl;

  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _shieldScale;
  late final Animation<double> _progressOpacity;
  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    // 진입 완료 후 pulse 시작
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _entranceCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _pulseCtrl.repeat(reverse: true);
      }
    });

    // 전체 콘텐츠: fade + 위로 float
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic),
    );

    // 쉴드: 추가 scale-in (조금 더 임팩트)
    _shieldScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.9, curve: Curves.easeOutBack),
      ),
    );

    // 진행바: 진입 후반부에 페이드
    _progressOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // 쉴드 pulse (진입 완료 후 시작됨)
    _pulseScale = Tween<double>(begin: 1.0, end: 1.035).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _opacity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 텍스트
                Image.asset(
                  'assets/images/splashLogo.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                // 쉴드: 진입 scale + 이후 pulse
                AnimatedBuilder(
                  animation: Listenable.merge([_entranceCtrl, _pulseCtrl]),
                  builder: (context, child) => Transform.translate(
                    offset: const Offset(0, -24),
                    child: Transform.scale(
                      scale: _shieldScale.value * _pulseScale.value,
                      child: child,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/shield.png',
                    width: 260,
                    height: 260,
                  ),
                ),
                const SizedBox(height: 48),
                // 진행바
                FadeTransition(
                  opacity: _progressOpacity,
                  child: Obx(
                    () => LinearProgressIndicator(
                      value: widget.controller.progress.value,
                      backgroundColor: AppColors.surfaceElements,
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
