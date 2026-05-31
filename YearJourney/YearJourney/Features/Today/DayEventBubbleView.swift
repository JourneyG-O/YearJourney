//
//  DayEventBubbleView.swift
//  YearJourney
//

import SwiftUI

struct DayEventBubbleView: View {
    let activeEvent: ActiveDayEvent

    // MARK: - Body

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            mainBubble
            thoughtDots
        }
    }

    // MARK: - Sections

    private var mainBubble: some View {
        HStack(spacing: 6) {
            Text(activeEvent.event.emoji)
                .font(.system(size: 22))

            VStack(alignment: .leading, spacing: 1) {
                if activeEvent.event.showTitle {
                    Text(activeEvent.event.title)
                        .font(.system(size: 11, weight: .medium))
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                }
                Text(dDayLabel)
                    .font(.custom("ComicRelief-Bold", size: 15))
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        // Liquid Glass (iOS 26+)
        .glassEffect(in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // 큰 원 → 중간 원 → 작은 원 순으로 동반자 방향으로 이어지는 점
    private var thoughtDots: some View {
        HStack(spacing: 5) {
            Spacer()
            ForEach([10, 7, 5] as [CGFloat], id: \.self) { size in
                Circle()
                    .frame(width: size, height: size)
                    .glassEffect()
            }
        }
        .padding(.trailing, 10)
    }

    // MARK: - Helpers

    private var dDayLabel: String {
        activeEvent.daysRemaining == 0 ? "D-Day!" : "D-\(activeEvent.daysRemaining)"
    }
}
