import 'package:flutter_test/flutter_test.dart';
import 'package:guard_up_app/app/data/models/risk_analysis_response.dart';

void main() {
  test('RiskAnalysisResponse parses API-shaped JSON', () {
    final response = RiskAnalysisResponse.fromJson({
      'score': 72,
      'level': 'caution',
      'issues': [
        {
          'clause': '수리비 부담 조항',
          'reason': '임차인에게 과도한 부담이 될 수 있습니다.',
          'severity': 2,
          'is_legal_basis': false,
        },
      ],
      'action_guide': [
        {
          'type': 'institution',
          'message': '전문 기관 상담을 권장합니다.',
          'name': '전월세 상담센터',
          'phone': '1234-5678',
        },
      ],
      'public_data': {
        'jeonse_ratio': '78%',
        'is_registered': true,
        'mortgage_amount': 120000000,
      },
      'mapping_table_purged': true,
    });

    expect(response.score, 72);
    expect(response.level, RiskLevel.caution);
    expect(response.issues.single.isLegalBasis, false);
    expect(response.actionGuide.single.name, '전월세 상담센터');
    expect(response.publicData.jeonseRatio, '78%');
    expect(response.mappingTablePurged, true);
  });
}
