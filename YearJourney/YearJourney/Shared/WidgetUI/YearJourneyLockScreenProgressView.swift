//
//  YearJourneyLockScreenProgressView.swift
//  YearJourney
//

import SwiftUI

// Lock screen 전용 프로그레스 뷰.
// 동반자 크기를 컨테이너 높이에 비례해서 조정.
// 목표 이미지 없음.
struct YearJourneyLockScreenProgressView: View {
    let progress: Double
    let theme: ThemeAssets

    var body: some View {
        GeometryReader { proxy in
            let width  = proxy.size.width
            let height = proxy.size.height

            let clampedProgress = max(0.0, min(1.0, progress))

            // 동반자를 높이의 85%로 조정
            let companionSize = height * 0.85
            let halfCompanion = companionSize / 2

            // 라인은 좌우 반 동반자 폭만큼 여백
            let lineStart = halfCompanion
            let lineEnd   = width - halfCompanion
            let lineWidth = lineEnd - lineStart

            let travelerX = lineStart + lineWidth * clampedProgress

            let lineThickness: CGFloat = 5
            // 라인 중심 Y: 하단 25% 지점
            let lineY = height * 0.75
            // 동반자 중심 Y: 발이 라인 위에 닿도록 (발 위치는 이미지 하단 25%)
            let companionY = lineY - companionSize * 0.25

            ZStack(alignment: .topLeading) {

                // MARK: Progress line
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.25))
                        .frame(width: lineWidth, height: lineThickness)
                    Capsule()
                        .fill(Color.primary)
                        .frame(width: lineWidth * clampedProgress, height: lineThickness)
                }
                .position(x: lineStart + lineWidth / 2, y: lineY)

                // MARK: Companion
                Image(theme.companionImageName(isTintMode: true))
                    .resizable()
                    .scaledToFit()
                    .frame(width: companionSize, height: companionSize)
                    .position(x: travelerX, y: companionY)
            }
        }
    }
}
