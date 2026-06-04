//
//  YearJourneyLockScreenProgressView.swift
//  YearJourney
//

import SwiftUI

struct YearJourneyLockScreenProgressView: View {
    let progress: Double
    let theme: ThemeAssets

    var body: some View {
        GeometryReader { proxy in
            let width  = proxy.size.width
            let height = proxy.size.height

            let clampedProgress = max(0.0, min(1.0, progress))

            let companionSize = height * 0.85
            let halfCompanion = companionSize / 2

            let lineStart = halfCompanion
            let lineEnd   = width - halfCompanion
            let lineWidth = lineEnd - lineStart

            let travelerX = lineStart + lineWidth * clampedProgress

            let lineThickness: CGFloat = 5
            let lineY = height * 0.75
            let companionY = lineY - companionSize * 0.25

            ZStack(alignment: .topLeading) {

                // Progress line
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.25))
                        .frame(width: lineWidth, height: lineThickness)
                    Capsule()
                        .fill(Color.primary)
                        .frame(width: lineWidth * clampedProgress, height: lineThickness)
                }
                .position(x: lineStart + lineWidth / 2, y: lineY)

                // Companion
                Image(theme.companionImageName(isTintMode: false))
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: companionSize, height: companionSize)
                    .position(x: travelerX, y: companionY)
            }
        }
    }
}
