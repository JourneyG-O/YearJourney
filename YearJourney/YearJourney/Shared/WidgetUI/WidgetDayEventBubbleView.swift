//
//  WidgetDayEventBubbleView.swift
//  YearJourney
//

import SwiftUI

// Compact D-Day bubble for widget use.
// Positioned left or right of the companion based on progress.
struct WidgetDayEventBubbleView: View {
    let activeEvent: ActiveDayEvent
    let showOnRight: Bool   // true when progress < 0.5
    let showTitle: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if showOnRight {
                dots(reversed: false)
                mainBubble
            } else {
                mainBubble
                dots(reversed: true)
            }
        }
    }

    // MARK: - Sections

    private var mainBubble: some View {
        HStack(spacing: 4) {
            Text(activeEvent.event.emoji)
                .font(.system(size: 13))

            VStack(alignment: .leading, spacing: 0) {
                if showTitle {
                    Text(activeEvent.event.title)
                        .font(.system(size: 8, weight: .medium))
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                }
                Text(dDayLabel)
                    .font(.custom("ComicRelief-Bold", size: 11))
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 5)
        .glassEffect(in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func dots(reversed: Bool) -> some View {
        let sizes: [CGFloat] = reversed ? [3, 4, 5] : [5, 4, 3]
        return HStack(spacing: 3) {
            ForEach(sizes, id: \.self) { size in
                Circle()
                    .frame(width: size, height: size)
                    .glassEffect()
            }
        }
        .padding(.horizontal, 2)
    }

    // MARK: - Helpers

    private var dDayLabel: String {
        activeEvent.daysRemaining == 0 ? "D-Day!" : "D-\(activeEvent.daysRemaining)"
    }
}
