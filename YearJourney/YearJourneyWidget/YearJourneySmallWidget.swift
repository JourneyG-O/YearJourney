//
//  GoalFillWidget.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/21/25.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct YearJourneySmallEntry: TimelineEntry {
    let date: Date
    let fillProgress: Double
    let theme: ThemeAssets
}

// MARK: - Timeline Provider

struct YearJourneySmallProvider: TimelineProvider {

    private func currentTheme() -> ThemeAssets {
        let id = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        return ThemeCatalog.theme(for: id)
    }

    func placeholder(in context: Context) -> YearJourneySmallEntry {
        return YearJourneySmallEntry(
            date: Date(),
            fillProgress: 0.3,
            theme: ThemeCatalog.defaultTheme
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneySmallEntry) -> Void) {
        let progress = ProgressCalculator.goalFillProgress()
        let theme = currentTheme()
        let entry = YearJourneySmallEntry(
            date: Date(),
            fillProgress: progress,
            theme: theme
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneySmallEntry>) -> Void) {

        let date = Date()
        let progress = ProgressCalculator.goalFillProgress(for: date)
        let theme = currentTheme()
        let entry = YearJourneySmallEntry(
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

struct YearJourneySmallWidgetEntryView: View {
    let entry: YearJourneySmallEntry

    @Environment(\.widgetRenderingMode) private var renderingMode

    private var isTintMode: Bool { renderingMode == .accented }

    var body: some View {
        YearJourneySmallWidgetView(
            fillProgress: entry.fillProgress,
            theme: entry.theme,
            isTintMode: isTintMode
        )
        .containerBackground(.background, for: .widget)
    }
}

// MARK: - Widget 정의

struct YearJourneySmallWidget: Widget {
    let kind: String = "YearJourneySmallWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: YearJourneySmallProvider()) { entry in
            YearJourneySmallWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Goal Fill")
        .description("See how much of this month you've filled.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    YearJourneySmallWidget()
} timeline: {
    YearJourneySmallEntry(date: .now, fillProgress: 0.1, theme: .catBasic)
    YearJourneySmallEntry(date: .now, fillProgress: 0.5, theme: .catBasic)
    YearJourneySmallEntry(date: .now, fillProgress: 0.9, theme: .catBasic)
}

