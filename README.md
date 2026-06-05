# GuardUp (안심계약 가디언)

자립준비청년을 위한 AI 기반 임대차 계약서 분석 앱

---

## 프로젝트 소개

계약서 사진 한 장으로 독소 조항과 리스크를 자동 분석해주는 서비스입니다.
법률 지식이 없는 청년들도 계약 전 위험 요소를 쉽게 파악할 수 있습니다.

---

## 시작하기

### 요구 사항

- Flutter SDK 3.x 이상
- Dart SDK 3.x 이상
- Android Studio 또는 VSCode (Flutter/Dart 플러그인 설치)
- Android 에뮬레이터 또는 실제 기기

### 설치 및 실행

```bash
# 1. 저장소 클론
git clone <repo-url>
cd guard_up_app

# 2. 패키지 설치
flutter pub get

# 3. 앱 실행
flutter run
```

---

## 기술 스택

| 분류 | 사용 기술 |
|------|----------|
| Framework | Flutter |
| 상태관리 | GetX |
| 로컬 DB | sqflite |
| HTTP 통신 | http |
| 이미지 선택 | image_picker |
| 로컬 저장소 | shared_preferences, path_provider |

---

## 프로젝트 구조

```
lib/
├── main.dart
└── app/
    ├── constants/
    │   ├── app_constants.dart       # 색상, 여백 상수
    │   └── api_constants.dart       # API 엔드포인트
    ├── data/
    │   ├── models/                  # 데이터 모델
    │   │   ├── risk_analysis_response.dart
    │   │   ├── history_item.dart
    │   │   ├── analyze_image_response.dart
    │   │   ├── verify_address_response.dart
    │   │   └── building_response.dart
    │   └── providers/
    │       └── api_provider.dart    # API 통신
    ├── services/
    │   └── local_storage_service.dart  # 분석 이력 저장
    ├── routes/
    │   ├── app_routes.dart          # 라우트 경로 상수
    │   └── app_pages.dart           # 라우트 등록
    └── modules/
        ├── splash/                  # 스플래시 화면
        ├── home/                    # 홈 화면
        ├── scan/                    # 계약서 촬영
        ├── analyzing/               # AI 분석 중
        ├── result/                  # 분석 결과
        ├── history/                 # 분석 이력
        └── guide/                   # 상담 안내
```

각 모듈은 `views/` · `controllers/` · `bindings/` 로 구성됩니다.

---

## 화면 구성

| 화면 | 설명 |
|------|------|
| Splash | 앱 시작 화면, 2초 후 홈으로 이동 |
| Home | 메인 화면, 계약서 분석 시작 |
| Scan | 카메라/갤러리로 계약서 촬영 |
| Analyzing | AI 분석 진행 중 화면 (4단계) |
| Result | 리스크 분석 결과 (안전/주의/위험) |
| History | 이전 분석 이력 목록 |
| Guide | 자립 상담 및 피해 신고 안내 |

---

## Git 브랜치 전략

```
main        → 배포용 (직접 푸시 금지)
develop     → 통합 브랜치
feature/*   → 기능 개발 (예: feature/home-view)
```

### 작업 흐름

```bash
# 1. develop 최신화
git checkout develop
git pull origin develop

# 2. feature 브랜치 생성
git checkout -b feature/화면이름

# 3. 작업 후 커밋
git add .
git commit -m "feat: 홈 화면 UI 구현"

# 4. PR 생성 (feature → develop)
git push origin feature/화면이름
```

---

## 개발 규칙

- 아키텍처 및 코딩 컨벤션은 [CLAUDE.md](CLAUDE.md) 참고
- View 파일만 수정 (Controller/Binding/Model은 팀장이 관리)
- `print()` 대신 Logger 사용
- 매직 넘버 사용 금지 → `app_constants.dart`에 상수로 정의
