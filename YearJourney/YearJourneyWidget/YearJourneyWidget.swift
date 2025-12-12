//
//  YearJourneyWidget.swift
//  YearJourneyWidget
//
//  Created by KoJeongseok on 11/21/25.
//

import WidgetKit
import SwiftUI

struct YearJourneyEntry: TimelineEntry {
    let date: Date
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYear: Int
    let theme: ThemeAssets
}

struct Provider: TimelineProvider {

    private func currentTheme() -> ThemeAssets {
        let id = UserDefaults.standard.string(forKey: "selectedThemeID")
        return ThemeCatalog.theme(for: id)
    }

    func placeholder(in context: Context) -> YearJourneyEntry {
        let info = ProgressCalculator.yearProgress()
        let theme = currentTheme()
        return YearJourneyEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneyEntry) -> ()) {
        let info = ProgressCalculator.yearProgress()
        let theme = currentTheme()
        let entry = YearJourneyEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneyEntry>) -> ()) {
        let now = Date()
        let info = ProgressCalculator.yearProgress(for: now)
        let theme = currentTheme()

        let entry = YearJourneyEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYear,
            theme: theme
        )

        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct YearJourneyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        YearJourneyMediumWidgetView(
            progress: entry.progress,
            dayOfYear: entry.dayOfYear,
            totalDaysInYear: entry.totalDaysInYear,
            theme: entry.theme
        )
        .padding()
        .containerBackground(.background, for: .widget)
    }
}

struct YearJourneyMediumWidgetView: View {
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYear: Int
    let theme: ThemeAssets

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                YearJourneyProgressLineView(
                    progress: progress,
                    theme: theme
                )
                    .frame(height: 40)
                    .position(x: size.width / 2,
                              y: size.height / 2)

                VStack {
                    Spacer()
                    Text("\(dayOfYear) / \(totalDaysInYear) (\(Int(progress * 100))%)")
                        .font(.custom("ComicRelief-Bold", size: 16))
                        .opacity(0.8)
                        .padding(.bottom, 4)
                }
                .frame(width: size.width, height: size.height)
            }
        }
    }
}

struct YearJourneyProgressLineView: View {
    let progress: Double
    let theme: ThemeAssets

    @Environment(\.widgetRenderingMode) private var renderingMode

    private var isTintMode: Bool {
        renderingMode == .accented
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let width = size.width
            let height = size.height

            let clamped = max(0.0, min(1.0, progress))

            let goalReservedWidth: CGFloat = 28
            let lineWidth = max(0, width - goalReservedWidth)

            let lineY = height / 2
            let travelerX = lineWidth * clamped

            let companionName = theme.companionImageName(isTintMode: isTintMode)
            let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName


            ZStack {
                Capsule()
                    .frame(width: lineWidth, height: 8)
                    .opacity(0.25)
                    .position(x: lineWidth / 2, y: lineY)

                Capsule()
                    .frame(width: lineWidth * clamped, height: 8)
                    .position(x: (lineWidth * clamped) / 2, y: lineY)

                let companionSize: CGFloat = 60
                let footRatio: CGFloat = 6.0 / 8.0
                let footAlignOffset = companionSize * (footRatio - 0.5)

                Image(companionName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: companionSize, height: companionSize)
                    .position(
                        x: travelerX,
                        y: lineY - footAlignOffset
                    )

                Image(goalName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .position(
                        x: lineWidth + goalReservedWidth / 2,
                        y: lineY
                    )
            }
        }
    }
}

struct YearJourneyWidget: Widget {
    let kind: String = "YearJourneyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            YearJourneyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Year Journey")
        .description("See how far you are into the year.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    YearJourneyWidget()
} timeline: {
    YearJourneyEntry(date: .now, progress: 0.98, dayOfYear: 377, totalDaysInYear: 365, theme: .catBasic)
}
