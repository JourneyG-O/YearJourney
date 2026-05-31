//
//  DayEventBubbleView.swift
//  YearJourney
//

import SwiftUI

// Shared D-Day thought bubble for both TodayView (useGlass: true) and widget (useGlass: false).
// showOnRight: true  → bubble is RIGHT of companion → dots tilt left toward companion
// showOnRight: false → bubble is LEFT of companion  → dots tilt right toward companion
struct DayEventBubbleView: View {
    let activeEvent: ActiveDayEvent
    var showOnRight: Bool = true
    var showTitle: Bool = true
    var useGlass: Bool = true
    var compact: Bool = false

    // MARK: - Layout constants

    private var dotSizes: [CGFloat]   { compact ? [20, 16, 12] : [36, 28, 20] }
    private var dotSpacing: CGFloat    { compact ? -6         : -10        }
    private var dotShift: CGFloat      { compact ? 10          : 20        }
    private var emojiSize: CGFloat     { compact ? 16         : 30         }
    private var titleFontSize: CGFloat { compact ? 8          : 11         }
    private var dDayFontSize: CGFloat  { compact ? 11         : 15         }
    private var hPad: CGFloat          { compact ? 7          : 12         }
    private var vPad: CGFloat          { compact ? 5          : 8          }
    private var radius: CGFloat        { compact ? 20         : 32         }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center, spacing: dotSpacing) {
            mainBubble
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
            thoughtDots
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var mainBubble: some View {
        let content = HStack(spacing: compact ? 4 : 6) {
            Text(activeEvent.event.emoji)
                .font(.system(size: emojiSize))

            VStack(alignment: .leading, spacing: 1) {
                if showTitle {
                    Text(activeEvent.event.title)
                        .font(.system(size: titleFontSize, weight: .medium))
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                }
                Text(dDayLabel)
                    .font(.custom("ComicRelief-Bold", size: dDayFontSize))
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, hPad)
        .padding(.vertical, vPad)

        if useGlass {
            content
                .glassEffect(in: RoundedRectangle(cornerRadius: radius, style: .continuous))
        } else {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
    }

    // 대각선 점: 버블 아래, 동반자 방향으로 기울어짐
    private var thoughtDots: some View {
        VStack(spacing: dotSpacing) {
            ForEach(Array(dotSizes.enumerated()), id: \.0) { index, size in
                dotView(size: size)
                    .offset(x: showOnRight
                        ? -CGFloat(index) * dotShift   // 왼쪽으로 기울어짐 (동반자가 왼쪽)
                        :  CGFloat(index) * dotShift)  // 오른쪽으로 기울어짐 (동반자가 오른쪽)
            }
        }
    }

    @ViewBuilder
    private func dotView(size: CGFloat) -> some View {
        if useGlass {
            Circle()
                .frame(width: size, height: size)
                .glassEffect()
        } else {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size, height: size)
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
                                           showTitle: true, useGlass: true, compact: false)
                    }
                    VStack(spacing: 6) {
                        Text("showOnRight: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: false,
                                           showTitle: true, useGlass: true, compact: false)
                    }
                }

                HStack(spacing: 40) {
                    VStack(spacing: 6) {
                        Text("showTitle: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: true,
                                           showTitle: false, useGlass: true, compact: false)
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
                                           showTitle: true, useGlass: false, compact: true)
                    }
                    VStack(spacing: 6) {
                        Text("showOnRight: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: false,
                                           showTitle: true, useGlass: false, compact: true)
                    }
                }

                HStack(spacing: 40) {
                    VStack(spacing: 6) {
                        Text("showTitle: false").font(.caption2).foregroundStyle(.tertiary)
                        DayEventBubbleView(activeEvent: sample, showOnRight: true,
                                           showTitle: false, useGlass: false, compact: true)
                    }
                }
            }
        }
        .padding(24)
    }
    .background(Color(.systemGroupedBackground))
}
