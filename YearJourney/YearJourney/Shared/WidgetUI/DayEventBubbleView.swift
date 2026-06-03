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

    private var emojiSize: CGFloat     { compact ? 13 : 22 }
    private var titleFontSize: CGFloat { compact ? 8  : 11 }
    private var dDayFontSize: CGFloat  { compact ? 11 : 15 }
    private var hPad: CGFloat          { compact ? 10 : 16 }
    private var vPad: CGFloat          { compact ? 6  : 10 }

    // MARK: - Body

    var body: some View {
        HStack(spacing: compact ? 4 : 6) {
            Text(activeEvent.event.emoji)
                .font(.system(size: emojiSize))

            VStack(alignment: .leading, spacing: 1) {
                if showTitle {
                    Text(activeEvent.event.title)
                        .font(.system(size: titleFontSize, weight: .medium))
                        .lineLimit(1)
                }
                Text(dDayLabel)
                    .font(.custom("ComicRelief-Bold", size: dDayFontSize))
            }
        }
        .padding(.horizontal, hPad)
        .padding(.vertical, vPad)
        .background {
            Image("ui_speech_bubble")
                .resizable(capInsets: EdgeInsets(
                    top: 0, leading: 12,
                    bottom: 0, trailing: 11
                ))
                .scaleEffect(x: showOnRight ? 1 : -1, y: 1)
        }
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

            // ── TodayView 스타일 ──────────────────────────────
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

            // ── Widget 스타일 ─────────────────────────────────
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
