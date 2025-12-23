//
//  SmallWidgetConfig.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import Foundation

struct SmallWidgetConfig: Codable, Equatable {
    var displayMode: WidgetDisplayMode

    var backgroundHex: String?
    var barHex: String?
    var textHex: String?

    static let `default` = SmallWidgetConfig(
        displayMode: .percent,
        backgroundHex: nil,
        barHex: nil,
        textHex: nil
    )
}

extension SmallWidgetConfig {
    static func load(
        defaults: UserDefaults = AppGroupStore.defaults
    ) -> SmallWidgetConfig {
        guard let data = defaults.data(forKey: WidgetKeys.smallConfig) else {
            return .default
        }
        return (try? JSONDecoder().decode(SmallWidgetConfig.self, from: data)) ?? .default
    }

    func save(
        defaults: UserDefaults = AppGroupStore.defaults
    ) {
        guard let data = try? JSONEncoder().encode(self) else { return }
        defaults.set(data, forKey: WidgetKeys.smallConfig)
    }
}
