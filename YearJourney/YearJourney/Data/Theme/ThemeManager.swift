//
//  ThemeManager.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/9/25.
//

import Foundation
import WidgetKit
import Combine
import YearJourneyShared

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published private(set) var currentTheme: ThemeAssets

    private let userDefaults: UserDefaults

    init(defaults: UserDefaults = AppGroupStore.defaults) {
        self.userDefaults = defaults

        let savedID = defaults.string(forKey: WidgetKeys.selectedThemeID)
        self.currentTheme = ThemeCatalog.theme(for: savedID)
    }

    func selectTheme(_ theme: ThemeAssets) {
        // 1) 메모리 상태 업데이트
        currentTheme = theme

        // 2) 영구 저장
        userDefaults.set(theme.id.rawValue, forKey: WidgetKeys.selectedThemeID)

        // 3) 위젯들도 새 테마를 반영하도록 요청
        WidgetCenter.shared.reloadAllTimelines()
    }
}
