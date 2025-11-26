//
//  GoalFillWidget.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/21/25.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct GoalFillEntry: TimelineEntry {
    let date: Date
    let fillProgress: Double   // 0.0 ~ 1.0 (이번 달 진행률)
}

// MARK: - Timeline Provider

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

        // 1시간마다 업데이트 (추후 조절 가능)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? date
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Entry View (UI)

struct GoalFillWidgetEntryView: View {
    let entry: GoalFillEntry

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let progress = CGFloat(entry.fillProgress)

            ZStack {
                // 바닥 레이어
                RoundedRectangle(cornerRadius: 12)
                    .opacity(0.2)

                // 아래에서 위로 채워지는 레이어 (임시 사각형 버전)
                VStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: size.height * progress)
                }
                .padding(6)
            }
            .padding(8)
        }
        // iOS 18 위젯 필수 배경 지정
        .containerBackground(.background, for: .widget)
    }
}

// MARK: - Widget 정의

struct GoalFillWidget: Widget {
    let kind: String = "GoalFillWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GoalFillProvider()) { entry in
            GoalFillWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Goal Fill")
        .description("See how much of this month you've filled.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    GoalFillWidget()
} timeline: {
    GoalFillEntry(date: .now, fillProgress: 0.1)
    GoalFillEntry(date: .now, fillProgress: 0.5)
    GoalFillEntry(date: .now, fillProgress: 0.9)
}
