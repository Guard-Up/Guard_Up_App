import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splashLogo.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Transform.translate(
                offset: const Offset(0, -24),
                child: Image.asset(
                  'assets/images/shield.png',
                  width: 300,
                  height: 300,
                ),
              ),
              const SizedBox(height: 48),
              Obx(
                () => LinearProgressIndicator(
                  value: controller.progress.value,
                  backgroundColor: const Color(0xFFE8E8E8),
                  color: const Color(0xFF2969ED),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
