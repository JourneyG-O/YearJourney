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
        GeometryReader { proxy in
            let size = proxy.size
            let clamped = max(0.0, min(1.0, fillProgress))

            let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName

            ZStack {
                // 1) 바닥에 전체 생선 (베이스)
                Image(goalName)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.25)

                // 2) 아래에서 위로 채워지는 생선
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
                if let text = displayText {
                    VStack {
                        Spacer()
                        Text(text)
                            .font(.custom("ComicRelief-Bold", size: 16))
                            .foregroundStyle(.primary)
                            .opacity(0.8)
                            .shadow(radius: 2)
                            .padding(.bottom, 4)
                    }
                }
            }
            .padding(12)
        }
    }
}
