//
//  DayEventStore.swift
//  YearJourney
//

import Foundation

enum DayEventStore {

    static func load(defaults: UserDefaults = AppGroupStore.defaults) -> [DayEvent] {
        guard let data = defaults.data(forKey: WidgetKeys.dayEvents) else { return [] }
        return (try? JSONDecoder().decode([DayEvent].self, from: data)) ?? []
    }

    static func save(_ events: [DayEvent], defaults: UserDefaults = AppGroupStore.defaults) {
        guard let data = try? JSONEncoder().encode(events) else { return }
        defaults.set(data, forKey: WidgetKeys.dayEvents)
    }
}
