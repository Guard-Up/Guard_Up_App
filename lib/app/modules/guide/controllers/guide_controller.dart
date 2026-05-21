import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';

enum ChecklistStage { before, during, after }

extension ChecklistStageExt on ChecklistStage {
  String get label {
    switch (this) {
      case ChecklistStage.before:
        return '계약 전';
      case ChecklistStage.during:
        return '계약 시';
      case ChecklistStage.after:
        return '계약 후';
    }
  }

  String get key {
    switch (this) {
      case ChecklistStage.before:
        return 'before';
      case ChecklistStage.during:
        return 'during';
      case ChecklistStage.after:
        return 'after';
    }
  }
}

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class LimitationItem {
  final String id;
  final String title;
  final String body;
  final List<LimitationLink> links;

  const LimitationItem({
    required this.id,
    required this.title,
    required this.body,
    this.links = const [],
  });
}

enum LimitationLinkType { url, tel }

class LimitationLink {
  final String label;
  final String value;
  final LimitationLinkType type;

  const LimitationLink({
    required this.label,
    required this.value,
    required this.type,
  });
}

class GuideController extends GetxController {
  final expandedSection = RxnInt(0);
  final selectedStage = ChecklistStage.before.obs;
  final checkedItems = <String>{}.obs;

  late final SharedPreferences _prefs;
  static const _checklistPrefsKey = 'guide_checklist_checked';

  @override
  void onInit() {
    super.onInit();
    _loadCheckedItems();
  }

  Future<void> _loadCheckedItems() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs.getStringList(_checklistPrefsKey) ?? [];
    checkedItems.addAll(saved);
  }

  Future<void> _persistCheckedItems() async {
    await _prefs.setStringList(_checklistPrefsKey, checkedItems.toList());
  }

  String _checklistItemId(ChecklistStage stage, int index) =>
      '${stage.key}_$index';

  bool isChecked(ChecklistStage stage, int index) =>
      checkedItems.contains(_checklistItemId(stage, index));

  void onChecklistItemToggled(ChecklistStage stage, int index) {
    final id = _checklistItemId(stage, index);
    if (checkedItems.contains(id)) {
      checkedItems.remove(id);
    } else {
      checkedItems.add(id);
    }
    _persistCheckedItems();
  }

  void onSectionPressed(int index) {
    expandedSection.value = expandedSection.value == index ? null : index;
  }

  void onStagePressed(ChecklistStage stage) {
    selectedStage.value = stage;
  }

  void onLimitationPressed(LimitationItem item) {
    Get.toNamed(Routes.guideDetail, arguments: {'limitation': item});
  }

  void onFaqPressed(int index) {
    Get.toNamed(Routes.guideQna, arguments: {'initialIndex': index});
  }

  static const String limitationFooter =
      '※ 본 분석은 참고용이며 법률 자문이 아닙니다.';

  final List<LimitationItem> limitations = const [
    LimitationItem(
      id: 'mortgage',
      title: '근저당/가압류 직접 확인 필요',
      body: '현재 분석은 등기부등본 정보를 자동으로 확인하지 않습니다.\n'
          '근저당이나 가압류가 설정된 경우 경매 시 보증금 회수가 어려울 수 있어 '
          '계약 전 반드시 직접 확인이 필요합니다.\n\n'
          '확인 방법:\n'
          '• 인터넷등기소(iros.go.kr)에서 등기부등본 발급 (약 700원)\n'
          '• 계약 직전과 잔금 지급 전 두 번 확인 권장',
      links: [
        LimitationLink(
          label: '인터넷등기소 바로가기',
          value: 'https://www.iros.go.kr',
          type: LimitationLinkType.url,
        ),
      ],
    ),
    LimitationItem(
      id: 'landlord',
      title: '임대인 신원 검증',
      body: '임대인이 등기부등본상 실제 소유자와 일치하는지 직접 확인해야 합니다.\n'
          '대리인 계약, 위임장 등은 사기 위험이 있으므로 주의가 필요합니다.\n\n'
          '확인 방법:\n'
          '• 임대인 신분증과 등기부등본 소유자 정보 대조\n'
          '• 계약금/보증금은 임대인 본인 명의 계좌로만 입금',
    ),
    LimitationItem(
      id: 'insurance',
      title: '보증보험 가입 여부',
      body: '전세보증보험은 임대인이 보증금을 반환하지 못할 경우 '
          '보증기관이 대신 지급하는 제도입니다. 가입 가능 여부는 직접 확인이 필요합니다.\n\n'
          '문의처:\n'
          '• 주택도시보증공사(HUG): 1566-9009\n'
          '• SGI서울보증: 1670-7000',
      links: [
        LimitationLink(
          label: 'HUG 1566-9009',
          value: '15669009',
          type: LimitationLinkType.tel,
        ),
        LimitationLink(
          label: 'SGI서울보증 1670-7000',
          value: '16707000',
          type: LimitationLinkType.tel,
        ),
      ],
    ),
  ];

  List<String> get checklistItems {
    switch (selectedStage.value) {
      case ChecklistStage.before:
        return const [
          '등기부등본 발급 (소유자/근저당/가압류 확인)',
          '건축물대장 확인 (위반건축물 여부)',
          '시세 조회 (전세가율 70% 이하 권장)',
          '임대인 신분증과 등기부등본 소유자 대조',
        ];
      case ChecklistStage.during:
        return const [
          '임대인 본인 명의 계좌로 입금',
          '특약사항 꼼꼼히 확인',
          '표준임대차계약서 사용 확인',
          '계약서 사본 보관 (2부 작성)',
        ];
      case ChecklistStage.after:
        return const [
          '전입신고 (이사 당일)',
          '확정일자 받기 (이사 당일)',
          '전세보증보험 가입 검토',
          '임대차 신고 (30일 이내)',
        ];
    }
  }

  final List<FaqItem> faqs = const [
    FaqItem(
      question: '전세가율이 뭐예요?',
      answer:
          '매매가 대비 전세금 비율이에요. 예를 들어 매매가 3억 집에 전세 2.5억이면 '
          '전세가율 83%입니다.\n\n'
          '70% 이하는 안전, 80% 이상은 깡통전세 위험이 있어 주의가 필요해요.',
    ),
    FaqItem(
      question: '근저당이 뭐예요?',
      answer:
          '집을 담보로 잡힌 대출이에요. 임대인이 빚을 못 갚으면 집이 경매로 넘어가고 '
          '은행이 임차인보다 먼저 돈을 가져가요.\n\n'
          '근저당 금액이 크면 보증금을 못 돌려받을 위험이 있으니 계약 전 '
          '등기부등본에서 확인하세요.',
    ),
    FaqItem(
      question: '전입신고 꼭 해야 하나요?',
      answer:
          '네, 꼭 해야 해요. 전입신고를 해야 임차인 권리(대항력)가 생겨요.\n\n'
          '집이 팔리거나 임대인이 바뀌어도 계약 기간까지 살 수 있는 권리예요. '
          '주민센터나 정부24에서 무료로 가능합니다.',
    ),
    FaqItem(
      question: '확정일자는 왜 받아야 해요?',
      answer:
          '확정일자가 있어야 보증금 우선변제권이 생겨요. 집이 경매로 넘어가도 '
          '다른 채권자보다 먼저 보증금을 돌려받을 권리예요.\n\n'
          '발급처:\n'
          '• 주민센터(동주민센터): 무료\n'
          '• 인터넷등기소: 약 500원\n'
          '• 등기소 방문: 약 600원',
    ),
    FaqItem(
      question: '분석 결과가 "위험"이면 계약하면 안 되나요?',
      answer:
          '분석은 참고용이에요. 위험 신호가 있다면 자립지원 전담기관이나 '
          '법률 상담을 받고 신중하게 결정하세요.\n\n'
          '절대 분석 결과만 보고 100% 안전/위험으로 판단하지 마시고, '
          '직접 등기부등본 등을 확인하세요.',
    ),
  ];
}
