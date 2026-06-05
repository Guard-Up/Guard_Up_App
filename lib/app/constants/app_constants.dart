import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primaryBlue = Color(0xFF2969ED);
  static const Color positive = Color(0xFF7EB7F6);
  static const Color negative = Color(0xFFFB736A);

  // Neutrals
  static const Color textBlack = Color(0xFF000000);
  static const Color textSub = Color(0xFF666666);
  static const Color textDisable = Color(0xFF999999);
  static const Color borderDash = Color(0xFFB6B6B6);
  static const Color borderLine = Color(0xFFDDDDDD);
  static const Color surfaceElements = Color(0xFFE8E8E8);
  static const Color surfaceDefault = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // Risk levels
  static const Color safe = Color(0xFF2E7D32);
  static const Color caution = Color(0xFFFEBC2F);
  static const Color danger = Color(0xFFBF3020);
}

class AppSpacing {
  AppSpacing._();

  static const double contentHorizontal = 20.0;
  static const double contentHorizontalAlt = 24.0;
  static const double contentVertical = 20.0;
  static const double sectionGap = 40.0;
  static const double headerToContent = 16.0;
  static const double headerToTitle = 60.0;
  static const double textFieldGap = 28.0;
  static const double bottomButtonGap = 28.0;
}
