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
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> YearJourneyEntry {
        YearJourneyEntry(date: Date(), progress: 0.32)
    }

    func getSnapshot(in context: Context, completion: @escaping (YearJourneyEntry) -> ()) {
        let entry = YearJourneyEntry(date: Date(), progress: 0.32)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearJourneyEntry>) -> ()) {

        let entry = YearJourneyEntry(date: Date(), progress: 0.32)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct YearJourneyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        YearJourneyMediumWidgetView(progress: entry.progress)
            .padding()
            .containerBackground(.background, for: .widget)
    }
}

struct YearJourneyMediumWidgetView: View {
    var progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Year Journey")
                .font(.headline)

            ZStack(alignment: .leading) {
                GeometryReader { proxy in
                    let width = proxy.size.width

                    // Path
                    Capsule()
                        .frame(height: 6)
                        .opacity(0.3)

                    // 진행도
                    Capsule()
                        .frame(width: max(0, min(1, progress)) * width, height: 6)

                    // Traveler
                    let catX = max(0, min(1, progress)) * width
                    HStack {
                        Text("🐈")
                            .offset(x: catX - 10, y: -18)
                        Spacer()
                    }

                    // Goal
                    HStack {
                        Spacer()
                        Text("🐟")
                            .offset(y: 10)
                    }
                }
                .frame(height: 40)
            }

            // 하단 정보 텍스트
            Text("\(Int(progress * 100))% of the year")
                .font(.caption)
                .opacity(0.7)
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
        .supportedFamilies([.systemMedium]) // 일단 Mediunm만
    }
}

#Preview(as: .systemMedium) {
    YearJourneyWidget()
} timeline: {
    YearJourneyEntry(date: .now, progress: 0.32)
}
