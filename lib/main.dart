import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "GuardUp",
      initialRoute: AppPages.initial, // 홈 화면으로 시작!
      getPages: AppPages.routes,      // 우리가 정한 길들
      debugShowCheckedModeBanner: false,
    ),
  );
}