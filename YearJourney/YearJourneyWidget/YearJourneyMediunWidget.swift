//
//  YearJourneyWidget.swift
//  YearJourneyWidget
//
//  Created by KoJeongseok on 11/21/25.
//

import WidgetKit
import SwiftUI

struct YearJourneyMediumEntry: TimelineEntry {
    let date: Date
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYear: Int
    let theme: ThemeAssets
    let config: MediumWidgetConfig
}

struct YearJourneyMediumProvider: TimelineProvider {

    private func currentTheme() -> ThemeAssets {
        let id = UserDefaults.standard.string(forKey: "selectedThemeID")
        return ThemeCatalog.theme(for: id)
    }

    private func currentConfig() -> MediumWidgetConfig {
        MediumWidgetConfig.load()
    }

    func placeholder(in context: Context) -> YearJourneyMediumEntry {
        let info = ProgressCalculator.yearProgress()
        let theme = currentTheme()
        let config = currentConfig()

        return YearJourneyMediumEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme,
            config: config
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneyMediumEntry) -> ()) {
        let info = ProgressCalculator.yearProgress()
        let theme = currentTheme()
        let config = currentConfig()

        let entry = YearJourneyMediumEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme,
            config: config
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneyMediumEntry>) -> ()) {
        let now = Date()
        let info = ProgressCalculator.yearProgress(for: now)
        let theme = currentTheme()
        let config = currentConfig()

        let entry = YearJourneyMediumEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme,
            config: config
        )

        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct YearJourneyMediumWidgetEntryView : View {
    var entry: YearJourneyMediumProvider.Entry
    @Environment(\.widgetRenderingMode) private var renderingMode

    private var isTintMode: Bool { renderingMode == .accented }

    var body: some View {
        YearJourneyMediumWidgetView(
            progress: entry.progress,
            dayOfYear: entry.dayOfYear,
            totalDaysInYear: entry.totalDaysInYear,
            theme: entry.theme,
            config: entry.config,
            isTintMode: isTintMode
        )
        .padding()
        .containerBackground(.background, for: .widget)
    }
}

struct YearJourneyMediumWidget: Widget {
    let kind: String = "YearJourneyMediumWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: YearJourneyMediumProvider()) { entry in
            YearJourneyMediumWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Year Journey")
        .description("See how far you are into the year.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    YearJourneyMediumWidget()
} timeline: {
    YearJourneyMediumEntry(date: .now, progress: 0.98, dayOfYear: 377, totalDaysInYear: 365, theme: .catBasic, config: .default)
}
