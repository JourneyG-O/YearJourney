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
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> YearJourneyEntry {
        let info = ProgressCalculator.yearProgress()
        return YearJourneyEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYeal
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneyEntry) -> ()) {
        let info = ProgressCalculator.yearProgress()
        let entry = YearJourneyEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYeal
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneyEntry>) -> ()) {
        let now = Date()
        let info = ProgressCalculator.yearProgress(for: now)

        let entry = YearJourneyEntry(
            date: info.date,
            progress: info.progress,
            dayOfYear: info.dayOfYear,
            totalDaysInYear: info.totalDaysInYeal
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
            totalDaysInYear: entry.totalDaysInYear
        )
        .padding()
        .containerBackground(.background, for: .widget)
    }
}

struct YearJourneyMediumWidgetView: View {
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYear: Int

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                YearJourneyProgressLineView(progress: progress)
                    .frame(height: 40)
                    .position(x: size.width / 2,
                              y: size.height / 2)

                VStack {
                    Spacer()
                    //                    Text("\(Int(progress * 100))%")
                    Text("\(dayOfYear) / \(totalDaysInYear)")
                        .font(.caption)
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

            ZStack {
                Capsule()
                    .frame(width: lineWidth, height: 8)
                    .opacity(0.25)
                    .position(x: lineWidth / 2, y: lineY)

                Capsule()
                    .frame(width: lineWidth * clamped, height: 8)
                    .position(x: (lineWidth * clamped) / 2, y: lineY)

                Text("🐈")
                    .font(.system(size: 18))
                    .position(
                        x: travelerX,
                        y: lineY - 16
                    )

                Text("🐟")
                    .font(.system(size: 16))
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
    YearJourneyEntry(date: .now, progress: 0.32, dayOfYear: 377, totalDaysInYear: 365)
}
