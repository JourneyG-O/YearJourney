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

    // 개별 ID 관리 -> 프로 유저 여부 하나로 통합
    @Published var isProUser: Bool = false

    private init() {}

    /// 소유 여부 확인 로직 단순화
    func isOwned(_ theme: ThemeAssets) -> Bool {
        // 1. 프리미엄이 아니면(무료면) 무조건 소유
        if theme.isPremium == false { return true }

        // 2. 프리미엄이면 프로 유저일 때만 소유
        return isProUser
    }

    /// 구매 시 호출 (나중에 StoreKit 연동 시 이 함수에서 실제 결제 로직 수행)
    func purchasePro() {
        // TODO: StoreKit 결제 성공 시 true로 변경
        isProUser = true
    }

#if DEBUG
    func debugTogglePro() {
        isProUser.toggle()
    }
#endif
}
