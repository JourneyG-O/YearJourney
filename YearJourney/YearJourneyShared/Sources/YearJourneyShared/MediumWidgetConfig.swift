//
//  MediumWidgetConfig.swift
//  YearJourneyShared
//
//  Created by KoJeongseok on 12/23/25.
//

import Foundation

public struct MediumWidgetConfig: Codable, Equatable {
    public var displayMode: WidgetDisplayMode
    public var backgroundHex: String?
    public var barHex: String?
    public var textHex: String?

    public static var `default`: MediumWidgetConfig {
        MediumWidgetConfig(
            displayMode: .dayFraction,
            backgroundHex: nil,
            barHex: nil,
            textHex: nil
        )
    }

    public init(displayMode: WidgetDisplayMode, backgroundHex: String?, barHex: String?, textHex: String?) {
        self.displayMode = displayMode
        self.backgroundHex = backgroundHex
        self.barHex = barHex
        self.textHex = textHex
    }
}

public extension MediumWidgetConfig {

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
