//
//  TimedThemeEventManager.swift
//  YearJourney
//

import Foundation

/// TimedThemeEvent의 발동 판단 및 상태 저장을 담당
/// AppGroupStore만 사용하므로 앱/위젯 양쪽 타겟에서 동일하게 호출 가능
enum TimedThemeEventManager {

    // MARK: - State

    static func isShown(_ event: TimedThemeEvent) -> Bool {
        AppGroupStore.defaults.bool(forKey: shownKey(event))
    }

    // MARK: - Condition Check

    /// 이벤트 테마로 전환할지 판단
    /// 첫 호출 시점을 기록해두고, cutoffDate 기준으로 기존/신규 유저 대기일을 다르게 적용
    static func shouldActivate(_ event: TimedThemeEvent) -> Bool {
        guard !isShown(event) else { return false }

        let currentThemeID = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        if currentThemeID == event.themeID.rawValue { return false }

        let now = Date()
        guard let firstSeen = AppGroupStore.defaults.object(forKey: firstSeenKey(event)) as? Date else {
            AppGroupStore.defaults.set(now, forKey: firstSeenKey(event))
            return false
        }

        let delay = firstSeen < event.cutoffDate ? event.existingUserDelay : event.newUserDelay
        let days = Calendar.current.dateComponents([.day], from: firstSeen, to: now).day ?? 0
        return days >= delay
    }

    // MARK: - Activation

    /// 이벤트 테마 적용 — 현재 테마를 저장하고 이벤트 테마로 전환
    static func activate(_ event: TimedThemeEvent) {
        let currentID = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
            ?? ThemeID.catBasic.rawValue
        AppGroupStore.defaults.set(currentID, forKey: originalThemeKey(event))
        AppGroupStore.defaults.set(event.themeID.rawValue, forKey: WidgetKeys.selectedThemeID)
    }

    // MARK: - Completion

    /// 온보딩 완료 — 기존 테마 복구 및 이벤트 완료 플래그 저장
    static func complete(_ event: TimedThemeEvent) {
        AppGroupStore.defaults.set(true, forKey: shownKey(event))

        let originalID = AppGroupStore.defaults.string(forKey: originalThemeKey(event))
        AppGroupStore.defaults.set(originalID ?? ThemeID.catBasic.rawValue, forKey: WidgetKeys.selectedThemeID)
    }

    // MARK: - Debug

    #if DEBUG
    /// 이벤트 상태 초기화 — 다시 처음 감지된 것처럼 동작
    static func reset(_ event: TimedThemeEvent) {
        AppGroupStore.defaults.removeObject(forKey: shownKey(event))
        AppGroupStore.defaults.removeObject(forKey: firstSeenKey(event))
        AppGroupStore.defaults.removeObject(forKey: originalThemeKey(event))
    }

    /// 대기일 조건을 무시하고 즉시 이벤트 테마로 전환
    static func debugForceActivate(_ event: TimedThemeEvent) {
        reset(event)
        activate(event)
    }
    #endif

    // MARK: - Key Helpers

    private static func shownKey(_ event: TimedThemeEvent) -> String {
        "event.\(event.id).shown"
    }

    private static func firstSeenKey(_ event: TimedThemeEvent) -> String {
        "event.\(event.id).firstSeen"
    }

    private static func originalThemeKey(_ event: TimedThemeEvent) -> String {
        "event.\(event.id).originalThemeID"
    }
}
