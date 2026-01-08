//
//  YearJourneyMediumWidgetView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import SwiftUI
#if canImport(WidgetKit)
import WidgetKit
#endif

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
        ZStack {
            YearJourneyProgressLineView(
                progress: progress,
                theme: theme,
                isTintMode: isTintMode
            )
            .frame(maxHeight: .infinity)

            if let text = displayText {
                VStack {
                    Spacer()
                    Text(text)
                        .font(.custom("ComicRelief-Bold", size: 16))
                        .opacity(0.8)
                        .padding(.bottom, 2)
                }
            }
        }
        .padding(16)
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

            // 1. 진행률 계산
            let clamped = max(0.0, min(1.0, progress))

            let goalReservedWidth: CGFloat = 28
            let lineWidth = max(0, width - goalReservedWidth)

            let lineY = height / 2
            let travelerX = lineWidth * clamped

            // 2. 이미지 이름 설정
            let companionName = theme.companionImageName(isTintMode: isTintMode)
            let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName

            // 3. 지우개(Mask)용 이미지 이름 구하기
            // 틴트 모드일 때만 사용: '_tint'가 없는 꽉 찬(일반) 이미지를 가져와서 지우개로 씁니다.
            let eraserImageName = isTintMode ? companionName.replacingOccurrences(of: "_tint", with: "") : ""

            // 4. 고양이 위치/크기 공통 변수 (라인과 지우개, 실제 고양이 모두 똑같은 위치여야 함)
            let companionSize: CGFloat = 85
            let footRatio: CGFloat = 6.0 / 8.0
            let footAlignOffset = companionSize * (footRatio - 0.5)

            ZStack {
                // ==========================================================
                // [Layer 1] 프로그레스 바 그룹 (배경 + 채움)
                // 틴트 모드일 때만 '지우개 마스크'를 적용해 구멍을 뚫습니다.
                // ==========================================================
                ZStack {
                    // 배경 라인
                    Capsule()
                        .frame(width: lineWidth, height: 8)
                        .opacity(0.25)
                        .position(x: lineWidth / 2, y: lineY)

                    // 채워진 라인
                    Capsule()
                        .frame(width: lineWidth * clamped, height: 8)
                        .position(x: (lineWidth * clamped) / 2, y: lineY)
                }
                .mask {
                    if isTintMode {
                        // [마스크 로직]
                        // 흰색 = 보여줌, 검은색/지워짐 = 숨김
                        ZStack {
                            // 1. 전체를 보여주는 하얀 도화지
                            Rectangle().fill(Color.white)

                            // 2. 고양이 모양만큼 '투명하게 지워냄' (DestinationOut)
                            Image(eraserImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: companionSize, height: companionSize)
                                .position(x: travelerX, y: lineY - footAlignOffset)
                                .blendMode(.destinationOut)
                        }
                        .compositingGroup()
                    } else {
                        Rectangle().fill(Color.white)
                    }
                }
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

// 안전한 WidgetAccentable 래퍼 (앱 타겟 빌드 에러 방지용)
extension View {
    @ViewBuilder
    func widgetAccentableSafe(_ isAccentable: Bool) -> some View {
        #if canImport(WidgetKit)
        if #available(iOS 16.0, *) {
            self.widgetAccentable(isAccentable)
        } else {
            self
        }
        #else
        self
        #endif
    }
}
