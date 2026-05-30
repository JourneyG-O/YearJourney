//
//  WidgetConfig.swift
//  YearJourney
//

import Foundation

struct WidgetConfig: Codable, Equatable {
    var displayMode: WidgetDisplayMode
    var backgroundHex: String?
    var barHex: String?
    var textHex: String?

    static func defaultConfig(for kind: WidgetKind) -> WidgetConfig {
        switch kind {
        case .small:
            return WidgetConfig(displayMode: .percent, backgroundHex: nil, barHex: nil, textHex: nil)
        case .medium:
            return WidgetConfig(displayMode: .dayFraction, backgroundHex: nil, barHex: nil, textHex: nil)
        }
    }
}

extension WidgetConfig {
    static func load(for kind: WidgetKind, defaults: UserDefaults = AppGroupStore.defaults) -> WidgetConfig {
        let key = kind == .small ? WidgetKeys.smallConfig : WidgetKeys.mediumConfig
        guard let data = defaults.data(forKey: key) else {
            return defaultConfig(for: kind)
        }
        return (try? JSONDecoder().decode(WidgetConfig.self, from: data)) ?? defaultConfig(for: kind)
    }

    func save(for kind: WidgetKind, defaults: UserDefaults = AppGroupStore.defaults) {
        let key = kind == .small ? WidgetKeys.smallConfig : WidgetKeys.mediumConfig
        guard let data = try? JSONEncoder().encode(self) else { return }
        defaults.set(data, forKey: key)
    }
}
