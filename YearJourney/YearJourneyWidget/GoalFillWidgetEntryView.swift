//
//  GoalFillWidgetEntryView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/21/25.
//

import SwiftUI
import WidgetKit

struct GoalFillWidgetEntryView: View {
    let entry: GoalFillEntry

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .opacity(0.2)

                VStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: size.height * CGFloat(entry.fillProgress))
                }
            }
            .padding(12)
        }
    }
}
