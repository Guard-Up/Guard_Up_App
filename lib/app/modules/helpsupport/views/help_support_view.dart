import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../controllers/help_support_controller.dart';
import 'package:get/get.dart';

class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({super.key});

  static const _cardColor = Color(0xFFEFEFEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // ── 상단바 ──
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: AppSpacing.contentHorizontal,
        title: Row(
          children: [
            Image.asset('assets/images/shield.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text(
              '안심 계약 가디언',
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.textBlack, size: 28),
            tooltip: '홈',
            onPressed: controller.onHomePressed,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentHorizontal,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            const Text(
              '피해를 입으셨나요?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '전세 사기 피해 신고',
              style: TextStyle(fontSize: 13, color: AppColors.textSub),
            ),
            const SizedBox(height: 20),

            // 피해 상담 기관 카드
            _buildAgencyCard(),
            const SizedBox(height: 16),

            // 국토부 연결 링크 버튼
            _buildMolitLink(),
            const SizedBox(height: 28),

            // 전세사기 피해자 강령
            _buildGuideline(),
          ],
        ),
      ),
      // ── 하단 네비게이션 (자립상담과 동일) ──
      bottomNavigationBar: _BottomNav(controller: controller),
    );
  }

  // ── 피해 상담 기관 카드 ─────────────────────────────────
  Widget _buildAgencyCard() {
    const agencies = [
      ['경찰청', '112'],
      ['LH콜센터', '1600-1004'],
      ['전세피해지원센터', '1533-8119'],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '피해 상담 기관',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 14),
          ...agencies.map(
            (a) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(Icons.circle, size: 5, color: AppColors.textBlack),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    a[0],
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.phone, size: 16, color: AppColors.danger),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => controller.callNumber(a[1]),
                    child: Text(
                      a[1],
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 국토부 연결 링크─────────────
  Widget _buildMolitLink() {
    return InkWell(
      onTap: controller.openMolitWebsite,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.account_balance,
                  color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              '국토부 연결 링크',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
            const Spacer(),
            const Icon(Icons.open_in_new, size: 18, color: AppColors.textSub),
          ],
        ),
      ),
    );
  }

  // ── 전세사기 피해자 강령 ────────────────────────────────
  Widget _buildGuideline() {
    const items = [
      [
        '주거지 확보와 대항력 유지',
        '절대 서두르지 마세요. 보증금을 돌려받기 전까지 다른 곳으로 '
            '주소지를 옮기면 안 됩니다. 대항력과 우선변제권이 상실될 수 있습니다.\n'
            '임차권등기 명령 신청 : 부득이하게 이사를 가야 한다면 반드시 \'임차권등기 '
            '명령\'이 완료(등기부등본 기재된)됨을 확인하고 이동해야 대항력이 유지됩니다.',
      ],
      [
        '증거 자료 수집 및 보존',
        '서류 일체 확보 : 임대차 계약서 원본, 입금 내역(송금 확인증), '
            '공인중개사 명함, 중개대상물 설명서 등을 한곳에 모으세요.\n'
            '커뮤니케이션 기록 : 집주인과의 통화 녹취, 문자 메시지, 카카오톡 대화 '
            '내용을 모두 캡처하고 백업해 두세요. (집주인의 연락 두절 여부 등)',
      ],
      [
        '공식 피해 확인 및 지원 요청',
        '전세피해지원센터 방문 : HUG(주택도시보증공사)에서 운영하는 지원센터를 통해 '
            '법률·상담, 심리 상담, 긴급 주거 지원 안내를 받으세요.\n'
            '전세사기 피해자 결정 신청 : 전세사기 피해자 지원 및 주거안정에 관한 '
            '특별법에 따라 관할 시·도에 피해자 결정 신청을 하세요. 인정을 받으면 '
            '경매 유예, 저리 대출 등 다양한 지원의 혜택을 받을 수 있습니다.',
      ],
      [
        '법적 조치 검토',
        '내용증명 발송 : 계약 해지 의사 및 보증금 반환 요청을 공식화하기 위해 '
            '내용증명을 발송하세요. (집주인이 수령하지 않아도 의사표시의 근거가 됩니다.)\n'
            '형사 고소 및 민사 소송 : 사기 혐의가 짙다면 형사 고소를, 보증금 반환을 '
            '위해서는 전세보증금 반환 소송을 검토하세요. 법률 구조공단 등의 '
            '전문가 도움을 받으세요.',
      ],
      [
        '정보 공유와 연대',
        '피해자 대책위 참여 : 해당 건물이나 지역의 다른 피해자들과 정보를 공유하세요. '
            '공동 대응은 심리적 지지뿐 아니라 법적 대응 시에도 효율적입니다.',
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '전세사기 피해자 강령',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(items.length, (i) {
          final title = items[i][0];
          final body = items[i][1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}. $title',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 6),
                // 본문(여러 줄)을 점 항목으로 표시
                ...body.split('\n').map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(Icons.circle,
                                  size: 4, color: AppColors.textSub),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                line,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textSub,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ── 하단 네비게이션 바──────────────────
class _BottomNav extends StatelessWidget {
  final HelpSupportController controller;
  const _BottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderLine)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.segment, size: 28, color: AppColors.textBlack),
                tooltip: '최근 기록',
                onPressed: controller.onHistoryPressed,
              ),
              IconButton(
                icon: const Icon(Icons.photo_camera_outlined, size: 30, color: AppColors.textBlack),
                tooltip: '계약서 촬영',
                onPressed: controller.onScanPressed,
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, size: 28, color: AppColors.primaryBlue),
                tooltip: '사용자',
                onPressed: controller.onUserPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}