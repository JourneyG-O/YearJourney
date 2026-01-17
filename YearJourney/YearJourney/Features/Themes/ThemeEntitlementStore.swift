//
//  ThemeEntitlementStore.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/16/25.
//

import SwiftUI
import Combine

class ThemeEntitlementStore: ObservableObject {
    static let shared = ThemeEntitlementStore()

    // 📡 StoreManager 연결
    private let storeManager = StoreManager.shared
    private var cancellables = Set<AnyCancellable>()

    private init() {
        // 🔗 연결 고리: StoreManager의 구매 상태(isPurchased)가 변하면
        // ThemeEntitlementStore도 "나 변했어!"라고 뷰에게 알림을 보냄
        storeManager.$isPurchased
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    // 🔒 소유 여부 확인 (이름을 isOwned로 유지)
    func isOwned(_ theme: ThemeAssets) -> Bool {
        // 1. 무료 테마는 무조건 통과!
        if !theme.isPremium {
            return true
        }

        // 2. 유료 테마라면? 실제 StoreManager의 구매 상태 확인
        return storeManager.isPurchased
    }
}
