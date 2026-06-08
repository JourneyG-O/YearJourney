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
    let config: WidgetConfig
}

// MARK: - Timeline Provider

struct YearJourneySmallProvider: TimelineProvider {

    private func activateBoxEventIfNeeded() {
        guard !AppGroupStore.defaults.bool(forKey: WidgetKeys.boxEventShown) else { return }
        let selectedThemeID = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        guard selectedThemeID != ThemeID.boxCat.rawValue else { return }

        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let triggeredVersion = AppGroupStore.defaults.string(forKey: WidgetKeys.boxEventVersion) ?? ""

        var shouldActivate = false
        if !triggeredVersion.isEmpty && currentVersion != triggeredVersion {
            shouldActivate = true
        } else if let setupDate = AppGroupStore.defaults.object(forKey: WidgetKeys.widgetFirstSetupDate) as? Date {
            let days = Calendar.current.dateComponents([.day], from: setupDate, to: Date()).day ?? 0
            shouldActivate = days >= 5
        }

        guard shouldActivate else { return }
        AppGroupStore.defaults.set(selectedThemeID ?? ThemeID.catBasic.rawValue, forKey: WidgetKeys.boxEventOriginalThemeID)
        AppGroupStore.defaults.set(currentVersion, forKey: WidgetKeys.boxEventVersion)
        AppGroupStore.defaults.set(ThemeID.boxCat.rawValue, forKey: WidgetKeys.selectedThemeID)
    }

    private func currentTheme() -> ThemeAssets {
        let id = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        return ThemeCatalog.theme(for: id)
    }

    private func currentConfig() -> WidgetConfig {
        WidgetConfig.load(for: .small)
    }

    func placeholder(in context: Context) -> YearJourneySmallEntry {
        return YearJourneySmallEntry(
            date: Date(),
            progress: 0.3,
            dayOfMonth: 10,
            totalDaysInMonth: 30,
            theme: ThemeCatalog.defaultTheme,
            config: WidgetConfig.defaultConfig(for: .small)
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
            config: config
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneySmallEntry>) -> Void) {
        activateBoxEventIfNeeded()
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
            config: config
        )

        // Schedule: booster at +5 minutes for quicker reflection after reloads, and hourly cadence thereafter
        let boosterDate = Calendar.current.date(byAdding: .minute, value: 5, to: now) ?? now
        let hourlyDate = Calendar.current.date(byAdding: .hour, value: 1, to: now) ?? now

        let boosterEntry = YearJourneySmallEntry(
            date: boosterDate,
            progress: info.progress,
            dayOfMonth: info.dayOfMonth,
            totalDaysInMonth: info.totalDaysInMonth,
            theme: theme,
            config: config
        )

        let timeline = Timeline(entries: [entry, boosterEntry], policy: .after(hourlyDate))
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
        .containerBackground(entry.theme.widgetBackground, for: .widget)
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
        config: WidgetConfig.defaultConfig(for: .small)
    )
}

