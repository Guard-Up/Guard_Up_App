class ResultConstants {
  ResultConstants._();

  // 위험 등급 점수 경계 (백엔드 판정 기준과 동일)
  // 0 ~ 69: danger / 70 ~ 89: caution / 90 ~ 100: safe
  static const int maxScore = 100;
  static const int cautionMinScore = 70;
  static const int safeMinScore = 90;
}
