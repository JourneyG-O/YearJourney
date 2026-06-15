//
//  YearJourneyApp.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/19/25.
//

import SwiftUI

@main
struct YearJourneyApp: App {
    @StateObject private var storeManager = StoreManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dayEventManager = DayEventManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(storeManager)
                .environmentObject(themeManager)
                .environmentObject(dayEventManager)
                .task {
                    await storeManager.updateCustomerProductStatus()

                    // 타이밍 테마 이벤트 조건 체크 — 충족 시 자동으로 이벤트 테마 적용
                    for event in TimedThemeEvent.all where TimedThemeEventManager.shouldActivate(event) {
                        TimedThemeEventManager.activate(event)
                        themeManager.refresh()
                        break
                    }
                }
        }
    }
}
