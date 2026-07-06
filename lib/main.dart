import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/constants/app_constants.dart';
import 'app/routes/app_pages.dart';
import 'app/services/local_storage_service.dart';
import 'app/utils/system_ui_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUiHelper.hideBottomNavBar(); // 하단 시스템바 숨김 (전역 적용)
  Get.put(LocalStorageService(), permanent: true);
  await Get.find<LocalStorageService>().init();
  runApp(const GuardUpApp());
}

class GuardUpApp extends StatelessWidget {
  const GuardUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '안심 계약 가디언',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textBlack,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
