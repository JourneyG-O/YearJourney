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
    let config: WidgetConfig
    let activeDayEvent: ActiveDayEvent?
}

struct YearJourneyMediumProvider: TimelineProvider {

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
        WidgetConfig.load(for: .medium)
    }

    private func currentDayEvent() -> ActiveDayEvent? {
        guard AppGroupStore.defaults.bool(forKey: WidgetKeys.isPurchased) else { return nil }
        let events = DayEventStore.load()
        return DayEventCalculator.activeEvent(from: events)
    }

    func placeholder(in context: Context) -> YearJourneyMediumEntry {
        let info = ProgressCalculator.yearProgress()
        return YearJourneyMediumEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: currentTheme(),
            config: currentConfig(),
            activeDayEvent: nil
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneyMediumEntry) -> ()) {
        let info = ProgressCalculator.yearProgress()
        let entry = YearJourneyMediumEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: currentTheme(),
            config: currentConfig(),
            activeDayEvent: currentDayEvent()
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneyMediumEntry>) -> ()) {
        activateBoxEventIfNeeded()
        let now = Date()
        let info = ProgressCalculator.yearProgress(for: now)
        let theme = currentTheme()
        let config = currentConfig()
        let activeEvent = currentDayEvent()

        let entry = YearJourneyMediumEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme,
            config: config,
            activeDayEvent: activeEvent
        )

        let boosterDate = Calendar.current.date(byAdding: .minute, value: 5, to: now) ?? now
        let hourlyDate = Calendar.current.date(byAdding: .hour, value: 1, to: now) ?? now

        let boosterEntry = YearJourneyMediumEntry(
            date: boosterDate,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme,
            config: config,
            activeDayEvent: activeEvent
        )

        let timeline = Timeline(entries: [entry, boosterEntry], policy: .after(hourlyDate))
        completion(timeline)
    }
}

struct YearJourneyMediumWidgetEntryView: View {
    var entry: YearJourneyMediumProvider.Entry
    @Environment(\.widgetRenderingMode) private var renderingMode

    private var isTintMode: Bool { renderingMode == .accented }

    private var bubbleTapURL: URL? {
        guard let event = entry.activeDayEvent else { return nil }
        return URL(string: "yearjourney://dday/\(event.event.id.uuidString)")
    }

    // 박스 테마일 때 위젯 전체 탭 → 온보딩으로 연결
    private var boxEventURL: URL? {
        entry.theme.themeID == .boxCat
            ? URL(string: "yearjourney://box-event")
            : nil
    }

    var body: some View {
        YearJourneyMediumWidgetView(
            progress: entry.progress,
            dayOfYear: entry.dayOfYear,
            totalDaysInYear: entry.totalDaysInYear,
            theme: entry.theme,
            config: entry.config,
            isTintMode: isTintMode,
            activeDayEvent: entry.activeDayEvent,
            bubbleTapURL: bubbleTapURL
        )
        .padding()
        .containerBackground(entry.theme.widgetBackground, for: .widget)
        .widgetURL(boxEventURL)
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
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    YearJourneyMediumWidget()
} timeline: {
    YearJourneyMediumEntry(
        date: .now,
        progress: 0.3,
        dayOfYear: 110,
        totalDaysInYear: 365,
        theme: .catBasic,
        config: WidgetConfig.defaultConfig(for: .medium),
        activeDayEvent: nil
    )
}
