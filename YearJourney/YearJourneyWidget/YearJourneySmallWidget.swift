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
    let progress: Double
    let dayOfMonth: Int
    let totalDaysInMonth: Int
    let theme: ThemeAssets
    let config: SmallWidgetConfig
}

// MARK: - Timeline Provider

struct YearJourneySmallProvider: TimelineProvider {

    private func currentTheme() -> ThemeAssets {
        let id = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        return ThemeCatalog.theme(for: id)
    }

    private func currentConfig() -> SmallWidgetConfig {
        SmallWidgetConfig.load()
    }

    func placeholder(in context: Context) -> YearJourneySmallEntry {
        return YearJourneySmallEntry(
            date: Date(),
            progress: 0.3,
            dayOfMonth: 10,
            totalDaysInMonth: 30,
            theme: ThemeCatalog.defaultTheme,
            config: .default
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneySmallEntry) -> Void) {
        let now = Date()
        let info = ProgressCalculator.monthProgress(for: now)
        let theme = currentTheme()
        let config = currentConfig()

        let entry = YearJourneySmallEntry(
            date: now,
            progress: info.progress,
            dayOfMonth: info.dayOfMonth,
            totalDaysInMonth: info.totalDaysInMonth,
            theme: theme,
            config: .default
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneySmallEntry>) -> Void) {
        let now = Date()
        let info = ProgressCalculator.monthProgress(for: now)
        let theme = currentTheme()
        let config = currentConfig()

        let entry = YearJourneySmallEntry(
            date: now,
            progress: info.progress,
            dayOfMonth: info.dayOfMonth,
            totalDaysInMonth: info.dayOfMonth,
            theme: theme,
            config: config
        )

        // 1시간마다 업데이트 (추후 조절 가능)
        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
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
            fillProgress: entry.progress,
            dayOfMonth: entry.dayOfMonth,
            totalDaysInMonth: entry.totalDaysInMonth,
            theme: entry.theme,
            config: entry.config,
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
        .configurationDisplayName("Monthly Goal")
        .description("Check your progress for this month.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    YearJourneySmallWidget()
} timeline: {
    YearJourneySmallEntry(
        date: .now,
        progress: 0.15,
        dayOfMonth: 5,
        totalDaysInMonth: 30,
        theme: .catBasic,
        config: .default
    )
}

