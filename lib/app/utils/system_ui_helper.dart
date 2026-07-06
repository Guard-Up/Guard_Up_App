import 'package:flutter/services.dart';

/// 앱 전역 시스템 UI(상단 상태바 · 하단 시스템 네비게이션바) 표시 모드 헬퍼.
///
/// `main()`에서 한 번만 호출하면 앱 전체 화면에 적용된다.
/// (화면마다 따로 호출할 필요 없음)
class SystemUiHelper {
  SystemUiHelper._();

  /// 스와이프로 시스템바가 나타난 뒤 자동으로 다시 숨겨지기까지 대기 시간.
  static const Duration _autoHideDelay = Duration(seconds: 2);

  /// 하단 시스템 네비게이션바만 숨기는 몰입형 모드.
  ///
  /// - 상단 상태바(시간·배터리)는 그대로 유지
  /// - 평소엔 하단 시스템바가 숨겨져 앱이 화면을 꽉 채움
  /// - 사용자가 아래에서 위로 스와이프하면 하단바가 잠깐 나타났다가
  ///   [_autoHideDelay] 후 자동으로 다시 숨겨짐
  static void hideBottomNavBar() {
    _applyMode();
    // manual 모드는 시스템바가 다시 나타나도 스스로 숨기지 않으므로,
    // 나타났을 때(overlaysVisible) 잠시 후 다시 숨기도록 콜백을 등록한다.
    SystemChrome.setSystemUIChangeCallback((overlaysVisible) async {
      if (!overlaysVisible) return;
      await Future.delayed(_autoHideDelay);
      _applyMode();
    });
  }

  static void _applyMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top], // 상단만 유지 → 하단 시스템바 숨김
    );
  }
}
