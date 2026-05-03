import 'dart:convert';
import 'risk_analysis_response.dart';

class HistoryItem {
  final int? id;
  final String address;
  final int score;
  final RiskLevel level;
  final List<Issue> issues;
  final List<ActionGuide> actionGuide;
  final PublicData publicData;
  final DateTime createdAt;

  const HistoryItem({
    this.id,
    required this.address,
    required this.score,
    required this.level,
    required this.issues,
    required this.actionGuide,
    required this.publicData,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'address': address,
        'score': score,
        'level': level.name,
        'issues': jsonEncode(issues.map((e) => e.toJson()).toList()),
        'action_guide': jsonEncode(actionGuide.map((e) => e.toJson()).toList()),
        'public_data': jsonEncode(publicData.toJson()),
        'created_at': createdAt.toIso8601String(),
      };

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] as int?,
      address: map['address'] as String,
      score: map['score'] as int,
      level: RiskLevelExt.fromString(map['level'] as String),
      issues: (jsonDecode(map['issues'] as String) as List)
          .map((e) => Issue.fromJson(e as Map<String, dynamic>))
          .toList(),
      actionGuide: (jsonDecode(map['action_guide'] as String) as List)
          .map((e) => ActionGuide.fromJson(e as Map<String, dynamic>))
          .toList(),
      publicData: PublicData.fromJson(
          jsonDecode(map['public_data'] as String) as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
