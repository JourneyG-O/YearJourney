//
//  SmallWidgetConfig.swift
//  YearJourneyShared
//
//  Created by KoJeongseok on 12/23/25.
//

import Foundation

public struct SmallWidgetConfig: Codable, Equatable {
    public var displayMode: WidgetDisplayMode

    public var backgroundHex: String?
    public var barHex: String?
    public var textHex: String?

    public static var `default`: SmallWidgetConfig {
        SmallWidgetConfig(
            displayMode: .percent,
            backgroundHex: nil,
            barHex: nil,
            textHex: nil
        )
    }

    public init(
        displayMode: WidgetDisplayMode,
        backgroundHex: String? = nil,
        barHex: String? = nil,
        textHex: String? = nil
    ) {
        self.displayMode = displayMode
        self.backgroundHex = backgroundHex
        self.barHex = barHex
        self.textHex = textHex
    }
}

public extension SmallWidgetConfig {
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
