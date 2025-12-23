//
//  YearJourneyMediumWidgetView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import SwiftUI

struct YearJourneyMediumWidgetView: View {
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYear: Int
    let theme: ThemeAssets
    let config: MediumWidgetConfig
    let isTintMode: Bool

    private var displayText: String? {
        switch config.displayMode {
        case .dayFraction:
            return "\(dayOfYear) / \(totalDaysInYear)"
        case .percent:
            return "\(Int(progress * 100))%"
        case .dRemaining:
            let remaining = totalDaysInYear - dayOfYear
            return "D-\(remaining)"
        case .off:
            return nil
        }
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                YearJourneyProgressLineView(
                    progress: progress,
                    theme: theme,
                    isTintMode: isTintMode
                )
                    .frame(height: 40)
                    .position(x: size.width / 2,
                              y: size.height / 2)

                VStack {
                    Spacer()
                    if let text = displayText {
                        Text(text)
                            .font(.custom("ComicRelief-Bold", size: 16))
                            .opacity(0.8)
                            .padding(.bottom, 4)

                    }
                }
                .frame(width: size.width, height: size.height)
            }
        }
    }
}

struct YearJourneyProgressLineView: View {
    let progress: Double
    let theme: ThemeAssets
    let isTintMode: Bool

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let width = size.width
            let height = size.height

            let clamped = max(0.0, min(1.0, progress))

            let goalReservedWidth: CGFloat = 28
            let lineWidth = max(0, width - goalReservedWidth)

            let lineY = height / 2
            let travelerX = lineWidth * clamped

            let companionName = theme.companionImageName(isTintMode: isTintMode)
            let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName


            ZStack {
                Capsule()
                    .frame(width: lineWidth, height: 8)
                    .opacity(0.25)
                    .position(x: lineWidth / 2, y: lineY)

                Capsule()
                    .frame(width: lineWidth * clamped, height: 8)
                    .position(x: (lineWidth * clamped) / 2, y: lineY)

                let companionSize: CGFloat = 60
                let footRatio: CGFloat = 6.0 / 8.0
                let footAlignOffset = companionSize * (footRatio - 0.5)

                Image(companionName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: companionSize, height: companionSize)
                    .position(
                        x: travelerX,
                        y: lineY - footAlignOffset
                    )

                Image(goalName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .position(
                        x: lineWidth + goalReservedWidth / 2,
                        y: lineY
                    )
            }
        }
    }
}
