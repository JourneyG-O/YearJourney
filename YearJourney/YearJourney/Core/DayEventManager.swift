//
//  DayEventManager.swift
//  YearJourney
//

import SwiftUI
import WidgetKit

@MainActor
final class DayEventManager: ObservableObject {
    static let shared = DayEventManager()

    @Published private(set) var events: [DayEvent] = []

    var activeEvent: ActiveDayEvent? {
        DayEventCalculator.activeEvent(from: events)
    }

    private init() {
        events = DayEventStore.load()
    }

    // MARK: - Intent

    func add(_ event: DayEvent) {
        events.append(event)
        persist()
    }

    func update(_ event: DayEvent) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[index] = event
        persist()
    }

    func delete(id: UUID) {
        events.removeAll { $0.id == id }
        persist()
    }

    // MARK: - Private

    private func persist() {
        DayEventStore.save(events)
        WidgetCenter.shared.reloadTimelines(ofKind: "YearJourneyMediumWidget")
    }
}
