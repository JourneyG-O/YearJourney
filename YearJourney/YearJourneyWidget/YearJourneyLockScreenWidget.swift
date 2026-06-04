//
//  YearJourneyLockScreenWidget.swift
//  YearJourneyWidget
//

import WidgetKit
import SwiftUI

// MARK: - Entry

struct YearJourneyLockScreenEntry: TimelineEntry {
    let date: Date
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYear: Int
    let theme: ThemeAssets
}

// MARK: - Provider

struct YearJourneyLockScreenProvider: TimelineProvider {

    private func currentTheme() -> ThemeAssets {
        let id = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        return ThemeCatalog.theme(for: id)
    }

    func placeholder(in context: Context) -> YearJourneyLockScreenEntry {
        let info = ProgressCalculator.yearProgress()
        return YearJourneyLockScreenEntry(
            date: info.date, progress: info.progress,
            dayOfYear: info.dayOfYear, totalDaysInYear: info.totalDaysInYear,
            theme: currentTheme()
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneyLockScreenEntry) -> ()) {
        let info = ProgressCalculator.yearProgress()
        completion(YearJourneyLockScreenEntry(
            date: info.date, progress: info.progress,
            dayOfYear: info.dayOfYear, totalDaysInYear: info.totalDaysInYear,
            theme: currentTheme()
        ))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneyLockScreenEntry>) -> ()) {
        let now = Date()
        let info = ProgressCalculator.yearProgress(for: now)
        let theme = currentTheme()

        func makeEntry(date: Date) -> YearJourneyLockScreenEntry {
            YearJourneyLockScreenEntry(
                date: date, progress: info.progress,
                dayOfYear: info.dayOfYear, totalDaysInYear: info.totalDaysInYear,
                theme: theme
            )
        }

        let boosterDate = Calendar.current.date(byAdding: .minute, value: 5, to: now) ?? now
        let hourlyDate  = Calendar.current.date(byAdding: .hour,   value: 1, to: now) ?? now

        let timeline = Timeline(
            entries: [makeEntry(date: now), makeEntry(date: boosterDate)],
            policy: .after(hourlyDate)
        )
        completion(timeline)
    }
}

// MARK: - Entry View

struct YearJourneyLockScreenEntryView: View {
    var entry: YearJourneyLockScreenProvider.Entry

    var body: some View {
        YearJourneyProgressLineView(
            progress: entry.progress,
            theme: entry.theme,
            isTintMode: false,
            isPreview: false,
            showGoalImage: false,
            useOriginalRendering: true
        )
        .padding(.vertical, 4)
        .containerBackground(.background, for: .widget)
    }
}

// MARK: - Widget

struct YearJourneyLockScreenWidget: Widget {
    let kind: String = "YearJourneyLockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: YearJourneyLockScreenProvider()) { entry in
            YearJourneyLockScreenEntryView(entry: entry)
        }
        .configurationDisplayName("Year Journey")
        .description("See how far you are into the year.")
        .supportedFamilies([.accessoryRectangular])
        .contentMarginsDisabled()
    }
}

// MARK: - Preview

#Preview(as: .accessoryRectangular) {
    YearJourneyLockScreenWidget()
} timeline: {
    YearJourneyLockScreenEntry(
        date: .now, progress: 0.43,
        dayOfYear: 155, totalDaysInYear: 365,
        theme: .catBasic
    )
}
