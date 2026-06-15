# YearJourney — CLAUDE.md

## Role & Core Philosophy

You are a senior iOS developer and architecture specialist collaborating on this project.

- Always understand the **original intent** of existing code before modifying it.
- Refactor **incrementally (step-by-step)**, never rewrite everything at once.
- All UI is written in SwiftUI. Keep code clean and minimal.

---

## Project Overview

Year/month progress tracker with character themes (Companions). iPhone-only. App Store live (v1.1.1, Build 4).

| Key | Value |
|---|---|
| Bundle ID | `app.stannum.YearJourney` |
| App Group | `group.app.stannum.YearJourney` |
| IAP Product ID | `app.stannum.YearJourney.pro.lifetime` (lifetime, single product) |
| Custom Font | `ComicRelief-Bold` (used throughout the app) |
| StoreKit Config | `Resources/Products.storekit` |

---

## Architecture & Tech Stack

**Frameworks:** SwiftUI, WidgetKit, StoreKit, Combine

**Target architecture (goal):** Strict MVVM — business logic and complex state must not live inside Views.

**Current architecture (pre-refactor):** Singleton + ObservableObject pattern. `StoreManager.shared`, `ThemeManager.shared`, and `ThemeEntitlementStore.shared` are referenced directly from Views via `@StateObject` / `@ObservedObject`. Refactoring toward MVVM is a planned direction, not yet complete.

**Folder organization:** Feature-based (not type-based). Code is grouped by feature domain (e.g., `Features/Today`, `Features/Themes`), not by layer (Views/, Models/).

---

## Xcode Targets

| Target | Role |
|---|---|
| `YearJourney` | Main app |
| `YearJourneyWidget` | Widget extension (Small: monthly, Medium: yearly) |

Project file: `YearJourney/YearJourney.xcodeproj`

---

## Folder Structure

```
YearJourney/ (main app target)
├── App/YearJourneyApp.swift         # @main entry point
├── RootView.swift                   # TabView root (Today / Companions / Widgets / About)
├── StoreManager.swift               # IAP singleton (@MainActor)
│
├── Data/
│   ├── ProgressCalculator.swift     # Year/month progress calculation (pure enum, no state)
│   ├── Storage/AppGroupStore.swift  # App Group UserDefaults accessor
│   ├── Theme/
│   │   ├── ThemeAssets.swift        # ThemeID, ThemeAssets, ThemeCatalog
│   │   └── ThemeManager.swift       # Theme selection/persistence singleton
│   └── Widget/
│       ├── WidgetKeys.swift         # UserDefaults key constants
│       ├── DisplayMode.swift        # WidgetDisplayMode enum
│       ├── SmallWidgetConfig.swift
│       └── MediumWidgetConfig.swift
│
├── Features/
│   ├── Today/                       # TodayView, YearProgressBarView
│   ├── Themes/                      # ThemesView, ThemeRow, ThemeEntitlementStore
│   ├── Widgets/                     # WidgetsView, Small/MediumWidgetSettingsView
│   ├── Settings/                    # SettingsView, legal doc views
│   └── PayWall/                     # ProUpgradeView, ConfettiView
│
└── Shared/
    ├── WidgetUI/                    # ⚠️ Compiled into BOTH targets — see constraints below
    │   ├── YearJourneySmallWidgetView.swift
    │   └── YearJourneyMediumWidgetView.swift
    └── WidgetPreview/WidgetPreview.swift

YearJourneyWidget/ (widget extension target)
├── YearJourneySmallWidget.swift     # Small: Monthly Goal
├── YearJourneyMediumWidget.swift    # Medium: yearly progress
└── YearJourneyWidgetBundle.swift
```

---

## Core Data Flows

**Theme selection**
`ThemesView` → `ThemeManager.selectTheme()` → `AppGroupStore.defaults` (persisted) → `WidgetCenter.reloadAllTimelines()`

**Purchase state propagation**
`StoreManager.updateCustomerProductStatus()` → `isPurchased` publish → `ThemeEntitlementStore` (Combine sink) → `ThemesView`

**Widget rendering**
`AppGroupStore.defaults` (themeID + config JSON) → `TimelineProvider` → `Entry` → `Shared/WidgetUI/` views

---

## Critical Technical Constraints

**UserDefaults**
All persistent data shared with the widget **must** use `AppGroupStore.defaults`.
`UserDefaults.standard` is not accessible from the widget extension.

**Shared UI (`Shared/WidgetUI/`)**
These files are included in both the app and widget targets.
They must compile without WidgetKit imports and work correctly in both targets.

**Purchase gate**
Premium feature gating must go through `ThemeEntitlementStore.isOwned(_:)` or `StoreManager.isPurchased`.
Never write raw `isPremium` checks directly in Views.

**Singleton instances**
Do not call `init()` on `StoreManager`, `ThemeManager`, or `ThemeEntitlementStore` directly.
Always use `.shared`.

**WidgetKit & StoreKit**
These APIs are sensitive. Before and after any modification, verify error handling is thorough.
Timeline logic changes must be validated against edge cases (e.g., day rollover, leap years).

**Custom font**
All new `Text` must use `.font(.custom("ComicRelief-Bold", size: N))`.

---

## UI & Component Rules

- Keep the base UI minimal and simple, consistent with the app's character.
- Views that render character assets or graphic elements must be extracted as separate, reusable Dumb Views (no business logic).
- Naming follows Swift API Design Guidelines — clear, intuitive English, camelCase.

---

## Refactoring Rules (follow strictly)

### Intent Preservation — highest priority

Before modifying any existing code, **summarize to the user**:
1. What the original code was intended to do
2. How it currently behaves
3. What specifically is inefficient or problematic

**Do not output modified code until the user explicitly confirms** ("맞아, 진행해" or equivalent).
This rule applies to all logic changes. Minor formatting-only fixes (e.g., adding MARK comments, fixing indentation) may proceed without confirmation.

### Step-by-step process

1. Identify the problematic file and explain the issue (tight coupling, wrong state ownership, etc.)
2. Get confirmation before writing any replacement code
3. After refactoring, verify that all edge cases and error handling from the original code are preserved

### Code Style — One-Voice Policy

All code must read as if written by a single careful developer from the start:
- Consistent indentation, line breaks, brace placement, naming
- Fix messy line breaks and unnecessary whitespace whenever encountered, even without functional changes
- Use `// MARK: - Properties`, `// MARK: - Methods`, etc. consistently across all Views and ViewModels
- Follow Swift API Design Guidelines strictly; code intent should be self-evident without comments

---

## Commit Convention

Use emoji + Korean only. No English tags. One space between emoji and content.

```
[이모지] [한글 내용]
```

| Emoji | Meaning | When to use |
|---|---|---|
| ✨ | 기능 | 새로운 기능 추가, 콘텐츠 업데이트 |
| 🐛 | 버그 | 코드 오류 및 비정상 동작 수정 |
| 💄 | 디자인 | UI/UX 레이아웃, 색상, 애니메이션 스타일 수정 |
| ♻️ | 개선 | 리팩토링, 코드 구조 개선, 최적화 |
| 📝 | 문서 | README 작성, 주석 추가 및 수정 |
| 🚀 | 배포 | 앱 버전 출시 및 스토어 업로드 관련 작업 |

- End with noun form: `~추가`, `~수정`, `~개선`, `~삭제`
- One commit, one task — never mix bug fixes with feature additions
- Write so it's clear what changed and why when read later

```
✨ 캐릭터 낚시 애니메이션 추가
🐛 타이머 종료 시 알림 누락 수정
💄 메인 화면 고양이 아이콘 크기 조정
♻️ 데이터 저장 로직 비동기 처리로 개선
🚀 v1.0.2 앱스토어 심사 제출
```

---

## Build & Testing

- IAP simulator testing: use `Resources/Products.storekit`
- Widget testing: add widget directly to simulator home screen
- Widget timeline refresh: +5 min booster entry after reload, then hourly cadence

---

## Release History

| Version | Build | Date | Summary |
|---|---|---|---|
| 1.0.2 | 2 | 2026 이전 | 초기 출시 |
| 1.1.0 | 3 | 2026-06-09 | D-Day 기능, Underwater Journey 테마, 박스 이벤트 온보딩, 13개국 로컬라이징, 페이월 UI 개선, 앱 리뷰 요청 |
| 1.1.1 | 4 | 2026-06-15 | 박스 이벤트 발동 로직 수정 (TimedThemeEvent 시스템), 온보딩 4페이지 문구 개선 |

### v1.1.0 주요 변경사항
- **D-Day**: 이벤트 카운트다운, 위젯 말풍선 표시 (Journey Pass 전용)
- **Underwater Journey**: 신규 테마 추가 (위젯 배경 오션 그라디언트, 컨텐츠 흰색 고정)
- **박스 이벤트 온보딩**: 업데이트 알림 전략 — 위젯 타임라인에서 자동 발동 (기존 유저: 5일 경과 즉시, 신규 유저: 위젯 설정 후 5일)
- **로컬라이징**: `Localizable.xcstrings` — 온보딩/페이월/D-Day 알러트 13개 언어 지원
- **페이월**: 전체화면 전환, 혜택 항목 개선
- **앱 리뷰 요청**: 위젯 설정 이력 있는 유저가 탭 전환 시 발동

### v1.1.1 주요 변경사항
- **박스 이벤트 버그 수정**: v1.1.0의 발동 조건이 모든 유저에게 항상 false였던 문제 수정. `Core/TimedThemeEvent.swift` + `Core/TimedThemeEventManager.swift`로 재설계 — 이벤트별 `firstSeen` 날짜를 AppGroupStore에 기록하고, cutoffDate(2026-06-25) 기준으로 기존 유저(3일 후)/신규 유저(10일 후) 발동 시점을 분기. 앱/위젯 양쪽에서 동일하게 동작하며, 향후 이벤트는 `TimedThemeEvent.all`에 항목만 추가하면 재사용 가능
- **온보딩 4페이지 문구 개선**: 타이틀을 1~3페이지와 통일해 영문으로 고정, 서브타이틀(감사 메시지)을 더 진솔한 톤으로 재작성하고 13개 언어 번역
