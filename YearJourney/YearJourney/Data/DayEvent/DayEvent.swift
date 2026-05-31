//
//  DayEvent.swift
//  YearJourney
//

import Foundation

struct DayEvent: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var title: String
    var emoji: String
    var month: Int       // 1–12
    var day: Int         // 1–31
    var year: Int?       // nil when isRecurring is true
    var daysBeforeToShow: Int
    var isRecurring: Bool
}
