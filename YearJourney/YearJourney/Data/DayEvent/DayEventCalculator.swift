//
//  DayEventCalculator.swift
//  YearJourney
//

import Foundation

struct ActiveDayEvent {
    let event: DayEvent
    let daysRemaining: Int  // 0 = today
}

enum DayEventCalculator {

    static func activeEvent(
        from events: [DayEvent],
        on date: Date = Date(),
        calendar: Calendar = .current
    ) -> ActiveDayEvent? {
        let candidates = events.compactMap { event -> ActiveDayEvent? in
            guard let remaining = daysRemaining(for: event, from: date, calendar: calendar) else {
                return nil
            }
            guard remaining >= 0 else { return nil }
            // nil = 항상 표시, otherwise check time window
            if let window = event.daysBeforeToShow {
                guard remaining <= window else { return nil }
            }
            return ActiveDayEvent(event: event, daysRemaining: remaining)
        }

        // 활성 이벤트 중 가장 가까운 날짜 반환
        return candidates.min(by: { $0.daysRemaining < $1.daysRemaining })
    }

    // MARK: - Private

    private static func daysRemaining(
        for event: DayEvent,
        from today: Date,
        calendar: Calendar
    ) -> Int? {
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        guard let todayYear = todayComponents.year else { return nil }

        if event.isRecurring {
            // 올해 날짜 먼저 시도, 이미 지났으면 내년
            for yearOffset in 0...1 {
                var components = DateComponents()
                components.year = todayYear + yearOffset
                components.month = event.month
                components.day = event.day
                guard let targetDate = calendar.date(from: components) else { continue }
                let diff = calendar.dateComponents([.day], from: startOfDay(today, calendar: calendar), to: startOfDay(targetDate, calendar: calendar)).day ?? -1
                if diff >= 0 { return diff }
            }
            return nil
        } else {
            guard let year = event.year else { return nil }
            var components = DateComponents()
            components.year = year
            components.month = event.month
            components.day = event.day
            guard let targetDate = calendar.date(from: components) else { return nil }
            return calendar.dateComponents([.day], from: startOfDay(today, calendar: calendar), to: startOfDay(targetDate, calendar: calendar)).day
        }
    }

    private static func startOfDay(_ date: Date, calendar: Calendar) -> Date {
        calendar.startOfDay(for: date)
    }
}
