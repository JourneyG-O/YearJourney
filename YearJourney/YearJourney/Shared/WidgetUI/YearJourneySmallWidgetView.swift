//
//  YearJourneySmallWidget.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/18/25.
//

import SwiftUI

struct YearJourneySmallWidgetView: View {
    let fillProgress: Double
    let dayOfMonth: Int
    let totalDaysInMonth: Int
    let theme: ThemeAssets
    let config: SmallWidgetConfig
    let isTintMode: Bool

    private var displayText: String? {
        switch config.displayMode {
        case .dayFraction:
            return "\(dayOfMonth) / \(totalDaysInMonth)"
        case .percent:
            return "\(Int(fillProgress * 100))%"
        case .dRemaining:
            let remaining = totalDaysInMonth - dayOfMonth
            return "D-\(remaining)"
        case .off:
            return nil
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { proxy in
                let size = proxy.size
                let clamped = max(0.0, min(1.0, fillProgress))
                let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName

                ZStack {
                    Image(goalName)
                        .resizable()
                        .scaledToFit()
                        .opacity(0.25)
                        .position(x: size.width / 2, y: size.height / 2)

                    Image(goalName)
                        .resizable()
                        .scaledToFit()
                        .mask(
                            Rectangle()
                                .frame(
                                    width: size.width,
                                    height: size.height * CGFloat(clamped)
                                )
                                .position(
                                    x: size.width / 2,
                                    y: size.height - (size.height * CGFloat(clamped) / 2)
                                )
                        )
                        .position(x: size.width / 2, y: size.height / 2)
                }
            }
            .frame(maxHeight: .infinity)

            if let text = displayText {
                Text(text)
                    .font(.custom("ComicRelief-Bold", size: 16))
                    .foregroundStyle(.primary)
                    .opacity(0.8)
                    .padding(.top, 2)
            }
        }
        .padding(12)
    }
}
