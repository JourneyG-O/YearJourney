//
//  YearJourneyProgressLineView.swift
//  YearJourney
//

import SwiftUI

struct YearJourneyProgressLineView: View {
    let progress: Double
    let theme: ThemeAssets
    let isTintMode: Bool
    var isPreview: Bool = false
    var activeDayEvent: ActiveDayEvent? = nil

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height

            let goalSize: CGFloat = 40
            let lineWidth = width - goalSize / 2

            let clampedProgress = max(0.0, min(1.0, progress))
            let travelerX = lineWidth * clampedProgress

            let lineThickness: CGFloat = 8
            // Line baseline sits 14pt above the bottom edge to leave room for shadow/padding
            let baseY = height - 14
            let lineTopY = baseY - (lineThickness / 2)

            let companionSize: CGFloat = 85
            // Companion sprite has feet at 75% of height (3/4 of the 4×4 grid)
            let centerToFootDistance = companionSize * (0.75 - 0.5)
            let centerToBottomDistance = goalSize / 2

            let fixIndex: Int? = isPreview ? 0 : nil
            let companionName = theme.companionImageName(isTintMode: isTintMode, fixIndex: fixIndex)
            let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName
            let eraserName = isTintMode ? theme.companionImageName(isTintMode: false, fixIndex: fixIndex) : ""

            ZStack(alignment: .topLeading) {

                // MARK: Layer 1 — Progress line
                ZStack(alignment: .leading) {
                    Capsule().frame(width: lineWidth, height: lineThickness).opacity(0.25)
                    Capsule().frame(width: travelerX, height: lineThickness)
                }
                .position(x: lineWidth / 2, y: baseY)
                .mask {
                    if isTintMode {
                        ZStack {
                            Rectangle().fill(Color.white)
                            Image(eraserName)
                                .resizable().scaledToFit()
                                .frame(width: companionSize, height: companionSize)
                                .position(x: travelerX, y: lineTopY - centerToFootDistance)
                                .blendMode(.destinationOut)
                        }.compositingGroup()
                    } else {
                        Rectangle().fill(Color.white)
                    }
                }

                // MARK: Layer 2 — Goal image
                Image(goalName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: goalSize, height: goalSize)
                    .position(x: lineWidth, y: lineTopY - centerToBottomDistance)

                // MARK: Layer 3 — Companion image
                Image(companionName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: companionSize, height: companionSize)
                    .position(x: travelerX, y: lineTopY - centerToFootDistance)

                // MARK: Layer 4 — D-Day bubble (Pro only, passed from entry)
                if let event = activeDayEvent {
                    let showOnRight = clampedProgress < 0.5
                    WidgetDayEventBubbleView(activeEvent: event, showOnRight: showOnRight)
                        .position(
                            x: showOnRight
                                ? travelerX + companionSize / 2 + 4
                                : travelerX - companionSize / 2 - 4,
                            y: lineTopY - centerToFootDistance - 8
                        )
                        .fixedSize()
                }
            }
        }
    }
}
