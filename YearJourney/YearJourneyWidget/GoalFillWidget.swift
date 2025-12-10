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
    let fillProgress: Double
    let theme: ThemeAssets
}

// MARK: - Timeline Provider

struct GoalFillProvider: TimelineProvider {

    private func currentTheme() -> ThemeAssets {
        let id = UserDefaults.standard.string(forKey: "selectedThemeID")
        return ThemeCatalog.theme(for: id)
    }

    func placeholder(in context: Context) -> GoalFillEntry {
        return GoalFillEntry(
            date: Date(),
            fillProgress: 0.3,
            theme: ThemeCatalog.defaultTheme
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (GoalFillEntry) -> Void) {
        let progress = ProgressCalculator.goalFillProgress()
        let theme = currentTheme()
        let entry = GoalFillEntry(
            date: Date(),
            fillProgress: progress,
            theme: theme
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GoalFillEntry>) -> Void) {

        let date = Date()
        let progress = ProgressCalculator.goalFillProgress(for: date)
        let theme = currentTheme()
        let entry = GoalFillEntry(
            date: date,
            fillProgress: progress,
            theme: theme
        )

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
        GoalFillFishView(
            fillProgress: entry.fillProgress,
            theme: entry.theme
        )
        .containerBackground(.background, for: .widget)
    }
}

struct GoalFillFishView: View {
    let fillProgress: Double
    let theme: ThemeAssets

    @Environment(\.widgetRenderingMode) private var renderingMode

    private var isTintMode: Bool {
        renderingMode == .accented
    }
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let clamped = max(0.0, min(1.0, fillProgress))

            let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName

            ZStack {
                // 1) 바닥에 전체 생선 (베이스)
                Image(goalName)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.25)

                // 2) 아래에서 위로 채워지는 생선
                Image(goalName)
                    .resizable()
                    .scaledToFit()
                    .mask(
                        Rectangle()
                            .frame(
                                width: size.width,
                                height: size.height * CGFloat(clamped)
                            )
                            .position(
                                x: size.width / 2,
                                y: size.height - (size.height * CGFloat(clamped) / 2)
                            )
                    )
            }
            .padding(12)
        }
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
    GoalFillEntry(date: .now, fillProgress: 0.1, theme: .catBasic)
    GoalFillEntry(date: .now, fillProgress: 0.5, theme: .catBasic)
    GoalFillEntry(date: .now, fillProgress: 0.9, theme: .catBasic)
}
