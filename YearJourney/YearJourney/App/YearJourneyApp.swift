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

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(storeManager)

                .task {
                    print("🚀 앱 시작: 구매 내역 확인 중...")
                    await storeManager.updateCustomerProductStatus()
                }
        }
    }
}
