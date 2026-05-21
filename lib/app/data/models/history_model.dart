import 'package:flutter/material.dart';

class HistoryModel {
  final String id;
  final String type;     // 월세, 전세 등
  final String address;  // 도로명 주소
  final String date;     // 분석 날짜
  final int score;       // 위험 점수 (0 ~ 100)

  HistoryModel({
    required this.id,
    required this.type,
    required this.address,
    required this.date,
    required this.score,
  });

  // 점수에 따른 안전/주의/위험 텍스트 반환
  String get statusText {
    if (score >= 80) return '위험 $score';
    if (score >= 40) return '주의 $score';
    return '안전 $score';
  }

  // 점수에 따른 칩 배경색
  Color get chipColor {
    if (score >= 80) return const Color(0xFFFFEBEE); // 연빨강
    if (score >= 40) return const Color(0xFFFFFDE7); // 연노랑
    return const Color(0xFFE8F5E9); // 연초록
  }

  // 점수에 따른 텍스트 색상
  Color get textColor {
    if (score >= 80) return Colors.red.shade700;
    if (score >= 40) return Colors.amber.shade800;
    return Colors.green.shade700;
  }

  // 점수에 따른 아이콘
  IconData get icon {
    if (score >= 80) return Icons.home_outlined;
    return Icons.gpp_good_outlined;
  }
}