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
                }
        }
    }
}
