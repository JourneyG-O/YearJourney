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
        GeometryReader { proxy in
            let height = proxy.size.height
            let width  = proxy.size.width
            let progress = max(0.0, min(1.0, entry.progress))
            let companionSize = height * 0.9
            let barWidth = width - companionSize - 8

            HStack(spacing: 8) {
                Spacer().frame(width: barWidth * progress)

                Image(entry.theme.companionImageName(isTintMode: false))
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: companionSize, height: companionSize)

                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .overlay(alignment: .bottom) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.25))
                        .frame(height: 5)
                    Capsule()
                        .fill(Color.primary)
                        .frame(width: barWidth * progress, height: 5)
                }
                .padding(.leading, 0)
                .frame(width: barWidth)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 4)
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
