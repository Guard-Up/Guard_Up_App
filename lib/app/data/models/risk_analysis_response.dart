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
        return '안전';
      case RiskLevel.caution:
        return '보통';
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
}

class Issue {
  final String clause;
  final String reason;
  final int severity;

  const Issue({
    required this.clause,
    required this.reason,
    required this.severity,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      clause: json['clause'] as String,
      reason: json['reason'] as String,
      severity: json['severity'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'clause': clause,
        'reason': reason,
        'severity': severity,
      };
}

class ActionGuide {
  final String type; // stop, institution, legal
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
