import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/analysis/views/home_view.dart';
import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/support/bindings/support_binding.dart';
import '../modules/support/views/support_view.dart';

class AppPages {
  AppPages._();

  static const initial = '/home';

  static final routes = [
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/analysis',
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: '/history',
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: '/support',
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),
  ];
}