//
//  WidgetConfig.swift
//  YearJourney
//

import Foundation

struct WidgetConfig: Equatable {
    var displayMode: WidgetDisplayMode
    var backgroundHex: String?
    var barHex: String?
    var textHex: String?
    // Medium only — D-Day bubble display settings
    var showDayEvent: Bool
    var showDayEventTitle: Bool

    static func defaultConfig(for kind: WidgetKind) -> WidgetConfig {
        switch kind {
        case .small:
            return WidgetConfig(
                displayMode: .percent,
                backgroundHex: nil, barHex: nil, textHex: nil,
                showDayEvent: false, showDayEventTitle: false
            )
        case .medium:
            return WidgetConfig(
                displayMode: .dayFraction,
                backgroundHex: nil, barHex: nil, textHex: nil,
                showDayEvent: false, showDayEventTitle: false
            )
        }
    }
}

// MARK: - Codable (custom decoder for backward compatibility)
extension WidgetConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case displayMode, backgroundHex, barHex, textHex
        case showDayEvent, showDayEventTitle
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        displayMode = try c.decode(WidgetDisplayMode.self, forKey: .displayMode)
        backgroundHex = try c.decodeIfPresent(String.self, forKey: .backgroundHex)
        barHex = try c.decodeIfPresent(String.self, forKey: .barHex)
        textHex = try c.decodeIfPresent(String.self, forKey: .textHex)
        // New fields — default to false when loading older saved data
        showDayEvent = (try? c.decode(Bool.self, forKey: .showDayEvent)) ?? false
        showDayEventTitle = (try? c.decode(Bool.self, forKey: .showDayEventTitle)) ?? false
    }
}

// MARK: - Persistence
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
