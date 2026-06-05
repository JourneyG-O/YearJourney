//
//  ThemeAssets.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/9/25.
//

import Foundation

/// 앱에서 사용할 테마 ID
enum ThemeID: String, Codable, CaseIterable {
    case catBasic
    case catCheese
    case ponyMocha
    case ghostRoo
    case slimeJelly
    case boxCat         // 이벤트 전용 — 일반 선택 불가
}

/// 하나의 테마가 가지고 있는 모든 이미지 리소스 정보
struct ThemeAssets: Identifiable, Codable, Equatable {

    var id: ThemeID { themeID }

    let themeID: ThemeID
    let displayName: String

    let mainImageName: String
    let companionImages: [String]
    let companionTintImages: [String]

    let goalImageName: String
    let goalTintImageName: String

    let isPremium: Bool
    let productID: String? // StoreKit IAP Product ID (무료 테마면 nil)

    /// 목표 이미지를 안전하게 하나 선택해서 변환
    func goalImageName(isTintMode: Bool) -> String {
        isTintMode ? goalTintImageName : goalImageName
    }
}

/// 기본 테마 정의
extension ThemeAssets {
    static let catBasic = ThemeAssets(
        themeID: .catBasic,
        displayName: "Journey",
        mainImageName: "cat_journey_main",
        companionImages: [
            "cat_journey_01",
            "cat_journey_02",
            "cat_journey_03",
            "cat_journey_04"
        ],
        companionTintImages: [
            "cat_journey_01_tint",
            "cat_journey_02_tint",
            "cat_journey_03_tint",
            "cat_journey_04_tint"
        ],
        goalImageName: "cat_fish",
        goalTintImageName: "cat_fish_tint",
        isPremium: false,
        productID: nil
    )

    static let catCheese = ThemeAssets(
            themeID: .catCheese,
            displayName: "Cheese",
            mainImageName: "cat_cheese_main",
            companionImages: [
                "cat_cheese_01",
                "cat_cheese_02",
                "cat_cheese_03",
                "cat_cheese_04"
            ],
            companionTintImages: [
                "cat_journey_01_tint",
                "cat_journey_02_tint",
                "cat_journey_03_tint",
                "cat_journey_04_tint"
            ],
            goalImageName: "cat_fish",
            goalTintImageName: "cat_fish_tint",
            isPremium: true,
            productID: nil
        )

    static let ponyMocha = ThemeAssets(
            themeID: .ponyMocha,
            displayName: "Mocha",
            mainImageName: "pony_mocha_main",
            companionImages: [
                "pony_mocha_01",
                "pony_mocha_02",
                "pony_mocha_03",
                "pony_mocha_04"
            ],
            companionTintImages: [
                "pony_mocha_01_tint",
                "pony_mocha_02_tint",
                "pony_mocha_03_tint",
                "pony_mocha_04_tint"
            ],
            goalImageName: "pony_carrot",
            goalTintImageName: "pony_carrot_tint",
            isPremium: true,
            productID: nil
        )

    static let ghostRoo = ThemeAssets(
            themeID: .ghostRoo,
            displayName: "Roo",
            mainImageName: "ghost_roo_main",
            companionImages: [
                "ghost_roo_01",
                "ghost_roo_02",
                "ghost_roo_03",
                "ghost_roo_04"
            ],
            companionTintImages: [
                "ghost_roo_01_tint",
                "ghost_roo_02_tint",
                "ghost_roo_03_tint",
                "ghost_roo_04_tint"
            ],
            goalImageName: "ghost_pumpkin",
            goalTintImageName: "ghost_pumpkin_tint",
            isPremium: true,
            productID: nil
        )

    static let slimeJelly = ThemeAssets(
            themeID: .slimeJelly,
            displayName: "Jelly",
            mainImageName: "slime_jelly_main",
            companionImages: [
                "slime_jelly_01",
                "slime_jelly_02",
                "slime_jelly_03",
                "slime_jelly_04"
            ],
            companionTintImages: [
                "slime_jelly_01_tint",
                "slime_jelly_02_tint",
                "slime_jelly_03_tint",
                "slime_jelly_04_tint"
            ],
            goalImageName: "slime_potion",
            goalTintImageName: "slime_potion_tint",
            isPremium: true,
            productID: nil
        )

    // 이벤트 전용 — 상자 안에 들어간 Journey
    static let boxCat = ThemeAssets(
        themeID: .boxCat,
        displayName: "Box",
        mainImageName: "cat_box_main",
        companionImages: [
            "cat_box_01",
            "cat_box_02",
            "cat_box_03"
        ],
        companionTintImages: [
            "cat_box_01_tint",
            "cat_box_02_tint",
            "cat_box_03_tint"
        ],
        goalImageName: "cat_fish",
        goalTintImageName: "cat_fish_tint",
        isPremium: false,
        productID: nil
    )
}

extension ThemeAssets {
    func companionImageName(isTintMode: Bool, fixIndex: Int? = nil) -> String {
        let source = isTintMode ? companionTintImages : companionImages

        guard let first = source.first else {
            return isTintMode ? goalTintImageName : goalImageName
        }

        if let index = fixIndex, source.indices.contains(index) {
            return source[index]
        }

        return source.randomElement() ?? first
    }
}

/// 테마 카탈로그 (목록 모음)
enum ThemeCatalog {
    /// 일반 선택 가능한 테마 목록 (ThemesView에 노출)
    static let all: [ThemeAssets] = [
        .catBasic,
        .catCheese,
        .ponyMocha,
        .ghostRoo,
        .slimeJelly
    ]

    /// 이벤트 전용 테마 (ThemesView에 노출 안 함)
    static let eventOnly: [ThemeAssets] = [
        .boxCat
    ]

    /// 기본 테마 (앱 최초 실행 시 사용)
    static let defaultTheme: ThemeAssets = .catBasic
}

extension ThemeCatalog {
    static func theme(for id: String?) -> ThemeAssets {
        guard let id = id else { return defaultTheme }
        let allIncludingEvent = all + eventOnly
        return allIncludingEvent.first(where: { $0.id.rawValue == id }) ?? defaultTheme
    }
}
