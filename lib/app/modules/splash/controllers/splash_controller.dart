import 'dart:async';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startProgress();
  }

  void _startProgress() {
    const interval = Duration(milliseconds: 16);
    const totalMs = 2000;
    final increment = interval.inMilliseconds / totalMs;

    Timer.periodic(interval, (timer) {
      progress.value += increment;
      if (progress.value >= 1.0) {
        progress.value = 1.0;
        timer.cancel();
        Get.offAllNamed(Routes.home);
      }
    });
  }
}
