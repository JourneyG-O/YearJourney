//
//  ThemeManager.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/9/25.
//

import Foundation
import WidgetKit
import Combine

final class ThemeManager: ObservableObject {

    /// Singleton
    static let shared = ThemeManager()

    @Published private(set) var currentTheme: ThemeAssets

    private let storageKey = "selectedThemeID"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        let savedID = userDefaults.string(forKey: storageKey)
        let theme = ThemeCatalog.theme(for: savedID)
        self.currentTheme = theme
    }

    func selectTheme(_ theme: ThemeAssets) {
        // 1) 메모리 상태 업데이트
        currentTheme = theme

        // 2) 영구 저장
        userDefaults.set(theme.id.rawValue, forKey: storageKey)

        // 3) 위젯들도 새 테마를 반영하도록 요청
        WidgetCenter.shared.reloadAllTimelines()
    }
}
