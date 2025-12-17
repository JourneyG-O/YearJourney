//
//  MediumWidgetConfig.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import Foundation

struct MediumWidgetConfig: Codable, Equatable {
    var displayMode: WidgetDisplayMode

    var backgroundHex: String?
    var barHex: String?
    var textHex: String?

    static let `default` = MediumWidgetConfig(
        displayMode: .dayFraction,
        backgroundHex: nil,
        barHex: nil,
        textHex: nil
    )
}

extension MediumWidgetConfig {
    static func load(
        defaults: UserDefaults = AppGroupStore.defaults
    ) -> MediumWidgetConfig {
        guard let data = defaults.data(forKey: WidgetKeys.mediumConfig) else {
            return .default
        }
        return (try? JSONDecoder().decode(MediumWidgetConfig.self, from: data)) ?? .default
    }

    func save(
        defaults: UserDefaults = AppGroupStore.defaults
    ) {
        guard let data = try? JSONEncoder().encode(self) else { return }
        defaults.set(data, forKey: WidgetKeys.mediumConfig)
    }
}
