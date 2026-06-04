//
//  BoxEventManager.swift
//  YearJourney
//

import Foundation
import WidgetKit

enum BoxEventManager {

    // MARK: - State

    static var isBoxEventShown: Bool {
        AppGroupStore.defaults.bool(forKey: WidgetKeys.boxEventShown)
    }

    // MARK: - Condition Check

    /// 상자 이벤트를 발동할지 판단
    static func shouldActivateBoxTheme() -> Bool {
        // 이미 온보딩을 완료한 경우 발동 안 함
        guard !isBoxEventShown else { return false }
        // 이미 상자 테마가 적용된 경우 재발동 안 함
        let currentThemeID = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        if currentThemeID == ThemeID.boxCat.rawValue { return false }

        let currentVersion = AppVersion.string
        let triggeredVersion = AppGroupStore.defaults.string(forKey: WidgetKeys.boxEventVersion) ?? ""

        // 조건 1: 앱 버전이 올라간 기존 위젯 사용자
        if currentVersion != triggeredVersion && currentThemeID != nil {
            return true
        }

        // 조건 2: 위젯 첫 설정일로부터 5일 이상 경과한 신규 사용자
        if let setupDate = AppGroupStore.defaults.object(forKey: WidgetKeys.widgetFirstSetupDate) as? Date {
            let days = Calendar.current.dateComponents([.day], from: setupDate, to: Date()).day ?? 0
            if days >= 5 { return true }
        }

        return false
    }

    // MARK: - Activation

    /// 상자 이벤트 활성화 — 현재 테마를 저장하고 boxCat 적용
    static func activate(themeManager: ThemeManager) {
        let currentID = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
            ?? ThemeID.catBasic.rawValue
        AppGroupStore.defaults.set(currentID, forKey: WidgetKeys.boxEventOriginalThemeID)
        AppGroupStore.defaults.set(AppVersion.string, forKey: WidgetKeys.boxEventVersion)
        themeManager.selectTheme(.boxCat)
    }

    // MARK: - Completion

    /// 온보딩 완료 — 기존 테마 복구 및 이벤트 완료 플래그 저장
    static func complete(themeManager: ThemeManager) {
        AppGroupStore.defaults.set(true, forKey: WidgetKeys.boxEventShown)

        let originalID = AppGroupStore.defaults.string(forKey: WidgetKeys.boxEventOriginalThemeID)
        let original = ThemeCatalog.theme(for: originalID)
        themeManager.selectTheme(original)
    }

    // MARK: - Widget First Setup

    /// 위젯 첫 설정일 기록 (WidgetSettingsView 저장 시 최초 1회만)
    static func recordFirstSetupDateIfNeeded() {
        guard AppGroupStore.defaults.object(forKey: WidgetKeys.widgetFirstSetupDate) == nil else { return }
        AppGroupStore.defaults.set(Date(), forKey: WidgetKeys.widgetFirstSetupDate)
    }
}
