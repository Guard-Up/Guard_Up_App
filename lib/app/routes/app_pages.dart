import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import '../modules/analyzing/bindings/analyzing_binding.dart';
import '../modules/analyzing/views/analyzing_view.dart';
import '../modules/result/bindings/result_binding.dart';
import '../modules/result/views/result_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/guide/bindings/guide_binding.dart';
import '../modules/guide/views/guide_view.dart';
import '../modules/guide_qna/bindings/guide_qna_binding.dart';
import '../modules/guide_qna/views/guide_qna_view.dart';
import '../modules/guide_detail/bindings/guide_detail_binding.dart';
import '../modules/guide_detail/views/guide_detail_view.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.scan,
      page: () => const ScanView(),
      binding: ScanBinding(),
    ),
    GetPage(
      name: Routes.analyzing,
      page: () => const AnalyzingView(),
      binding: AnalyzingBinding(),
    ),
    GetPage(
      name: Routes.result,
      page: () => const ResultView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.guide,
      page: () => const GuideView(),
      binding: GuideBinding(),
    ),
    GetPage(
      name: Routes.guideQna,
      page: () => const GuideQnaView(),
      binding: GuideQnaBinding(),
    ),
    GetPage(
      name: Routes.guideDetail,
      page: () => const GuideDetailView(),
      binding: GuideDetailBinding(),
    ),
  ];
}
