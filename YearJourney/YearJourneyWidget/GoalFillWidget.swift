//
//  GoalFillWidget.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/21/25.
//

import WidgetKit
import SwiftUI

struct GoalFillWidget: Widget {
    let kind: String = "GoalFillWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GoalFillProvider()) { entry in
            GoalFillWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Goal Fill")
        .description("See how much of this month you've filled.")
        .supportedFamilies([.systemSmall])
    }
}
