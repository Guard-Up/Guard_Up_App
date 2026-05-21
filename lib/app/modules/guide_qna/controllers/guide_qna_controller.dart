import 'package:get/get.dart';
import '../../guide/controllers/guide_controller.dart';

class GuideQnaController extends GetxController {
  final GuideController _guideController = Get.find<GuideController>();
  final currentIndex = 0.obs;

  List<FaqItem> get faqs => _guideController.faqs;
  int get total => faqs.length;
  FaqItem get current => faqs[currentIndex.value];

  String get pageText => '${currentIndex.value + 1}/$total';
  bool get canGoPrev => currentIndex.value > 0;
  bool get canGoNext => currentIndex.value < total - 1;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['initialIndex'] is int) {
      final i = args['initialIndex'] as int;
      if (i >= 0 && i < total) currentIndex.value = i;
    }
  }

  void onPrevPressed() {
    if (canGoPrev) currentIndex.value--;
  }

  void onNextPressed() {
    if (canGoNext) currentIndex.value++;
  }
}
