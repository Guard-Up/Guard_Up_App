import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

enum RiskLevel { safe, caution, danger }

extension RiskLevelExt on RiskLevel {
  static RiskLevel fromString(String value) {
    switch (value) {
      case 'safe':
        return RiskLevel.safe;
      case 'caution':
        return RiskLevel.caution;
      case 'danger':
        return RiskLevel.danger;
      default:
        return RiskLevel.caution;
    }
  }

  String get label {
    switch (this) {
      case RiskLevel.safe:
        return '안심';
      case RiskLevel.caution:
        return '주의';
      case RiskLevel.danger:
        return '위험';
    }
  }

  String get message {
    switch (this) {
      case RiskLevel.safe:
        return '계약을 진행해도 좋습니다';
      case RiskLevel.caution:
        return '한번 더 검토하세요';
      case RiskLevel.danger:
        return '계약을 중지하세요';
    }
  }

  Color get color {
    switch (this) {
      case RiskLevel.safe:
        return AppColors.safe;
      case RiskLevel.caution:
        return AppColors.caution;
      case RiskLevel.danger:
        return AppColors.danger;
    }
  }
}

class Issue {
  final String clause;
  final String reason;
  final int severity;
  final bool isLegalBasis;
  final String? location; // 계약서상 위치 (예: "특약사항 1항")
  final int? page; // 몇 번째 이미지에서 나왔는지 (1부터)
  final String? legalBasis; // 근거 법령·조문 (예: "주택임대차보호법 제3조")

  const Issue({
    required this.clause,
    required this.reason,
    required this.severity,
    required this.isLegalBasis,
    this.location,
    this.page,
    this.legalBasis,
  });

  /// "2페이지 · 특약사항 1항" 형태의 위치 라벨. 둘 다 없으면 null (API 응답 가공)
  String? get locationLabel {
    final parts = [
      if (page != null) '$page페이지',
      if (location != null && location!.isNotEmpty) location!,
    ];
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }

  /// "근거: 주택임대차보호법 제3조". 근거가 없으면 null (API 응답 가공)
  String? get legalBasisLabel {
    if (legalBasis == null || legalBasis!.isEmpty) return null;
    return '근거: $legalBasis';
  }

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      clause: json['clause'] as String,
      reason: json['reason'] as String,
      severity: json['severity'] as int,
      isLegalBasis: json['is_legal_basis'] as bool? ?? false,
      location: json['location'] as String?,
      page: (json['page'] as num?)?.toInt(),
      legalBasis: json['legal_basis'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'clause': clause,
        'reason': reason,
        'severity': severity,
        'is_legal_basis': isLegalBasis,
        if (location != null) 'location': location,
        if (page != null) 'page': page,
        if (legalBasis != null) 'legal_basis': legalBasis,
      };
}

/// 행동 가이드 유형 (백엔드 action_guide[].type)
/// stop: 즉시 중단 / warning: 주의 / legal: 법률 안내 / institution: 기관 연결
enum ActionGuideType { stop, warning, legal, institution, unknown }

extension ActionGuideTypeExt on ActionGuideType {
  static ActionGuideType fromString(String value) {
    switch (value) {
      case 'stop':
        return ActionGuideType.stop;
      case 'warning':
        return ActionGuideType.warning;
      case 'legal':
        return ActionGuideType.legal;
      case 'institution':
        return ActionGuideType.institution;
      default:
        return ActionGuideType.unknown;
    }
  }

  String get label {
    switch (this) {
      case ActionGuideType.stop:
        return '즉시 중단';
      case ActionGuideType.warning:
        return '주의 사항';
      case ActionGuideType.legal:
        return '법률 안내';
      case ActionGuideType.institution:
        return '전문 기관 연결';
      case ActionGuideType.unknown:
        return '안내';
    }
  }

  Color get color {
    switch (this) {
      case ActionGuideType.stop:
        return AppColors.danger;
      case ActionGuideType.warning:
        return AppColors.caution;
      case ActionGuideType.legal:
        return AppColors.primaryBlue;
      case ActionGuideType.institution:
        return AppColors.primaryBlue;
      case ActionGuideType.unknown:
        return AppColors.textSub;
    }
  }

  IconData get icon {
    switch (this) {
      case ActionGuideType.stop:
        return Icons.do_not_disturb_on_rounded;
      case ActionGuideType.warning:
        return Icons.warning_amber_rounded;
      case ActionGuideType.legal:
        return Icons.balance_rounded;
      case ActionGuideType.institution:
        return Icons.apartment_rounded;
      case ActionGuideType.unknown:
        return Icons.info_outline_rounded;
    }
  }
}

class ActionGuide {
  final String type; // stop, warning, legal, institution
  final String? message;
  final String? name;
  final String? phone;
  final String? region;
  final String? address;
  final String? link;

  const ActionGuide({
    required this.type,
    this.message,
    this.name,
    this.phone,
    this.region,
    this.address,
    this.link,
  });

  /// 백엔드 문자열 type을 enum으로 변환 (API 응답 가공)
  ActionGuideType get typeEnum => ActionGuideTypeExt.fromString(type);

  factory ActionGuide.fromJson(Map<String, dynamic> json) {
    return ActionGuide(
      type: json['type'] as String,
      message: json['message'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      region: json['region'] as String?,
      address: json['address'] as String?,
      link: json['link'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        if (message != null) 'message': message,
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (region != null) 'region': region,
        if (address != null) 'address': address,
        if (link != null) 'link': link,
      };
}

class PublicData {
  final String jeonseRatio;
  final bool isRegistered;
  final int? mortgageAmount;

  const PublicData({
    required this.jeonseRatio,
    required this.isRegistered,
    this.mortgageAmount,
  });

  factory PublicData.fromJson(Map<String, dynamic> json) {
    return PublicData(
      jeonseRatio: json['jeonse_ratio'] as String,
      isRegistered: json['is_registered'] as bool,
      mortgageAmount: json['mortgage_amount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'jeonse_ratio': jeonseRatio,
        'is_registered': isRegistered,
        if (mortgageAmount != null) 'mortgage_amount': mortgageAmount,
      };
}

class RiskAnalysisResponse {
  final int score;
  final RiskLevel level;
  final List<Issue> issues;
  final List<ActionGuide> actionGuide;
  final PublicData publicData;
  final bool mappingTablePurged;

  const RiskAnalysisResponse({
    required this.score,
    required this.level,
    required this.issues,
    required this.actionGuide,
    required this.publicData,
    required this.mappingTablePurged,
  });

  factory RiskAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return RiskAnalysisResponse(
      score: json['score'] as int,
      level: RiskLevelExt.fromString(json['level'] as String),
      issues: (json['issues'] as List)
          .map((e) => Issue.fromJson(e as Map<String, dynamic>))
          .toList(),
      actionGuide: (json['action_guide'] as List)
          .map((e) => ActionGuide.fromJson(e as Map<String, dynamic>))
          .toList(),
      publicData:
          PublicData.fromJson(json['public_data'] as Map<String, dynamic>),
      mappingTablePurged: json['mapping_table_purged'] as bool,
    );
  }
}
