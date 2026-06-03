//
//  DayEventBubbleView.swift
//  YearJourney
//

import SwiftUI

// showOnRight: true  → bubble is RIGHT of companion → tail on left  (image default)
// showOnRight: false → bubble is LEFT of companion  → tail on right (image flipped)
struct DayEventBubbleView: View {
    let activeEvent: ActiveDayEvent
    var showOnRight: Bool = true
    var showTitle: Bool = true
    var compact: Bool = false

    // MARK: - Layout constants

    // bubbleHeight만 조절하면 28:19 비율 그대로 유지
    private var bubbleHeight: CGFloat  { compact ? 50  : 76  }
    private var bubbleWidth: CGFloat   { bubbleHeight * 28 / 19 }
    private var emojiSize: CGFloat     { compact ? 13  : 20  }
    private var titleFontSize: CGFloat { compact ? 8   : 11  }
    private var dDayFontSize: CGFloat  { compact ? 11  : 14  }

    // MARK: - Body

    var body: some View {
        ZStack {
            Image(systemName: "message.fill")
                .resizable()
                .scaledToFit()
                .frame(width: bubbleWidth, height: bubbleHeight)
                .foregroundStyle(.white)
                .scaleEffect(x: showOnRight ? 1 : -1, y: 1)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)

            VStack(alignment: .leading, spacing: 1) {
                if showTitle {
                    Text(activeEvent.event.title)
                        .font(.system(size: titleFontSize, weight: .medium))
                        .lineLimit(1)
                        .foregroundStyle(Color.black)
                }
                HStack(spacing: 3) {
                    Text(activeEvent.event.emoji)
                        .font(.system(size: emojiSize))
                    Text(dDayLabel)
                        .font(.custom("ComicRelief-Bold", size: dDayFontSize))
                        .foregroundStyle(Color.black)
                }
            }
        }
        .frame(width: bubbleWidth, height: bubbleHeight)
    }

    // MARK: - Helpers

    private var dDayLabel: String {
        activeEvent.daysRemaining == 0 ? "D-Day!" : "D-\(activeEvent.daysRemaining)"
    }
}

// MARK: - Preview

#Preview {
    let sample = ActiveDayEvent(
        event: DayEvent(
            title: "버스데이",
            emoji: "🎂",
            month: 6, day: 9,
            year: nil,
            daysBeforeToShow: nil,
            isRecurring: true
        ),
        daysRemaining: 7
    )

    ScrollView {
        VStack(spacing: 32) {

            Group {
                Text("TodayView (compact: false)")
                    .font(.caption).foregroundStyle(.secondary)

                HStack(spacing: 40) {
                    VStack(spacing: 6) {
                        Text("showOnRight: true").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: true,
                                           showTitle: true, compact: false)
                    }
                    VStack(spacing: 6) {
                        Text("showOnRight: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: false,
                                           showTitle: true, compact: false)
                    }
                }
            }

            Divider()

            Group {
                Text("Widget (compact: true)")
                    .font(.caption).foregroundStyle(.secondary)

                HStack(spacing: 40) {
                    VStack(spacing: 6) {
                        Text("showOnRight: true").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: true,
                                           showTitle: true, compact: true)
                    }
                    VStack(spacing: 6) {
                        Text("showOnRight: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: false,
                                           showTitle: true, compact: true)
                    }
                }
            }
        }
        .padding(24)
    }
    .background(Color(.systemGroupedBackground))
}
