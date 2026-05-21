import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../guide/controllers/guide_controller.dart';

class GuideDetailController extends GetxController {
  late final LimitationItem item;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['limitation'] is LimitationItem) {
      item = args['limitation'] as LimitationItem;
    } else {
      Get.back();
    }
  }

  Future<void> onLinkPressed(LimitationLink link) async {
    final uri = link.type == LimitationLinkType.tel
        ? Uri(scheme: 'tel', path: link.value)
        : Uri.parse(link.value);

    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        Get.snackbar('연결 실패', '링크를 열 수 없습니다.');
      }
    } on PlatformException {
      Get.snackbar('연결 실패', '링크를 열 수 없습니다.');
    }
  }
}
