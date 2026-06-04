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

                    // 상자 이벤트 조건 체크 — 충족 시 자동으로 boxCat 테마 적용
                    if BoxEventManager.shouldActivateBoxTheme() {
                        BoxEventManager.activate(themeManager: themeManager)
                    }
                }
        }
    }
}
