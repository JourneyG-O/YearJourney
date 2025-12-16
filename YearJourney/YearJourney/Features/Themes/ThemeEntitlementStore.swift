//
//  ThemeEntitlementStore.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/16/25.
//

import Foundation
import Combine

final class ThemeEntitlementStore: ObservableObject {
    static let shared = ThemeEntitlementStore()

    @Published private(set) var ownedThemeIDs: Set<ThemeID> = [.catBasic]

    private init() {}

    func isOwned(_ theme: ThemeAssets) -> Bool {
        if theme.isPremium == false { return true }
        return ownedThemeIDs.contains(theme.themeID)
    }

    func priceText(for theme: ThemeAssets) -> String? {
        // TODO: StoreKit 분이면 product.displayPrice로 교체
        guard theme.isPremium else { return nil }
        return "₩1,100"
    }

    func purchase(_ theme: ThemeAssets) {
        // TODO: StoreKit 결제 성공 후에만 추가
        ownedThemeIDs.insert(theme.themeID)
    }
}
