//
//  GoalFillProvider.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/21/25.
//

import Foundation
import WidgetKit

struct GoalFillProvider: TimelineProvider {

    func placeholder(in context: Context) -> GoalFillEntry {
        GoalFillEntry(date: Date(), fillProgress: 0.3)
    }

    func getSnapshot(in context: Context, completion: @escaping (GoalFillEntry) -> Void) {
        let progress = ProgressCalculator.goalFillProgress()
        let entry = GoalFillEntry(date: Date(), fillProgress: progress)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GoalFillEntry>) -> Void) {

        let date = Date()
        let progress = ProgressCalculator.goalFillProgress(for: date)
        let entry = GoalFillEntry(date: date, fillProgress: progress)

        // 1시간마다 업데이트 (추후 조절)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? date
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}
