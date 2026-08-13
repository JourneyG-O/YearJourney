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
    var compact: Bool = false
    var isTintMode: Bool = false

    // MARK: - Layout constants

    private var bubbleHeight: CGFloat  { compact ? 50  : 76  }
    private var bubbleWidth: CGFloat   { bubbleHeight * 28 / 19 }
    private var emojiSize: CGFloat     { compact ? 13  : 20  }
    private var dDayFontSize: CGFloat  { compact ? 11  : 14  }

    // MARK: - Body

    var body: some View {
        ZStack {
            // 말풍선 배경 — 틴트 모드에선 알파를 낮춰(반투명) 위에 얹히는
            // 불투명 심볼·텍스트와 알파 대비를 만든다. accented 렌더러는 알파를 존중한다.
            Image(systemName: "message.fill")
                .resizable()
                .scaledToFit()
                .frame(width: bubbleWidth, height: bubbleHeight)
                .foregroundStyle(.white)
                .opacity(isTintMode ? 0.4 : 1)
                .scaleEffect(x: showOnRight ? 1 : -1, y: 1)
                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)

            content
        }
        .frame(width: bubbleWidth, height: bubbleHeight)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if isTintMode {
            // 틴트(accented) 모드: 이모지는 단색 실루엣으로 뭉개지므로 매칭 SF Symbol로 대체하고,
            // 심볼·텍스트를 불투명 흰색으로 유지해 반투명 말풍선 배경과 대비시킨다.
            VStack(spacing: 1) {
                Image(systemName: DayEventEmoji.symbolName(for: activeEvent.event.emoji))
                    .font(.system(size: emojiSize))
                Text(dDayLabel)
                    .font(.custom("ComicRelief-Bold", size: dDayFontSize))
            }
            .foregroundStyle(.white)
        } else {
            VStack(spacing: 0) {
                Text(activeEvent.event.emoji)
                    .font(.system(size: emojiSize))
                Text(dDayLabel)
                    .font(.custom("ComicRelief-Bold", size: dDayFontSize))
                    .foregroundStyle(Color.black)
            }
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

            Group {
                Text("TodayView (compact: false)")
                    .font(.caption).foregroundStyle(.secondary)

                HStack(spacing: 40) {
                    VStack(spacing: 6) {
                        Text("showOnRight: true").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: true, compact: false)
                    }
                    VStack(spacing: 6) {
                        Text("showOnRight: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: false, compact: false)
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
                        DayEventBubbleView(activeEvent: sample, showOnRight: true, compact: true)
                    }
                    VStack(spacing: 6) {
                        Text("showOnRight: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: false, compact: true)
                    }
                }
            }
        }
        .padding(24)
    }
    .background(Color(.systemGroupedBackground))
}
