# Guard Up App

> 한이음 드림업 사회공헌 프로젝트 — **안심 계약 가디언**

자립준비청년을 위한 전세 계약서 AI 분석 모바일 앱

---

## 프로젝트 소개

전세 계약 경험이 부족한 자립준비청년이 계약서를 직접 촬영하면, AI가 위험 조항을 분석하여 안심/주의/위험 3단계로 결과를 제공합니다. 복잡한 법률 용어 없이 누구나 쉽게 계약서 리스크를 파악할 수 있도록 돕는 것이 목표입니다.

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| 프레임워크 | Flutter |
| 상태 관리 | GetX |
| 언어 | Dart |
| 백엔드 연동 | HTTP (FastAPI) |

---

## 개발 환경 버전

> 팀원 간 버전을 반드시 통일해야 합니다.

| 항목 | 버전 |
|------|------|
| Flutter | 3.38.5 (stable) |
| Dart | 3.10.4 |
| Android SDK | 35.0.0 |
| Android Gradle Plugin (AGP) | 8.11.1 |
| Kotlin | 2.2.20 |
| Java (JDK) | 17.0.18 (Temurin) |
| Xcode (iOS) | 15.2 |

---

## 주요 화면

- **메인 화면** — 앱 시작 및 안내
- **계약서 촬영 화면** — 카메라로 계약서 스캔
- **분석 결과 화면** — 안심 / 주의 / 위험 3단계 결과 표시
- **액션 가이드 화면** — 위험 항목별 대처 방법 안내

---

## 프로젝트 구조

```
lib/
├── main.dart
└── app/
    ├── modules/          # 화면별 모듈 (GetX)
    │   └── home/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    └── routes/           # 앱 라우팅
```

---

## 팀 구성

| 역할 | 담당자 |
|------|--------|
| 프론트엔드 (Flutter + Figma) | 해빈 |

---

## Git 브랜치 전략

```
main      → 배포용 (최종 안정 버전)
develop   → 개발 통합 브랜치
feature/* → 기능별 개발 브랜치
```

- 모든 작업은 `feature/*` 브랜치에서 진행
- PR 필수, 팀장 승인 후 `develop`에 머지

---

## 시작하기

### 사전 준비 (최초 1회)

**1. Flutter 설치 및 버전 확인**
```bash
flutter --version
# Flutter 3.38.5 이어야 함
# 다르면: flutter upgrade
```

**2. Android cmdline-tools 설치**

`https://developer.android.com/studio#command-line-tools-only` 에서 macOS용 zip 다운로드 후:
```bash
mkdir -p ~/Library/Android/sdk/cmdline-tools/latest
cp -r ~/Downloads/cmdline-tools/* ~/Library/Android/sdk/cmdline-tools/latest/
```

**3. 환경변수 설정 (~/.zshrc)**
```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.zshrc
source ~/.zshrc
```

**4. Android 라이선스 동의**
```bash
flutter doctor --android-licenses
# 모두 y 입력 (한영 전환 확인!)
```

**5. 환경 확인**
```bash
flutter doctor
# [✓] Flutter, [✓] Android toolchain 확인
```

---

### 프로젝트 실행

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run
```
