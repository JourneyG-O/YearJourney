import SwiftUI
#if canImport(WidgetKit)
import WidgetKit
#endif

// MARK: - 메인 위젯 뷰 (컨테이너)
struct YearJourneyMediumWidgetView: View {
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYear: Int
    let theme: ThemeAssets
    let config: MediumWidgetConfig
    let isTintMode: Bool
    var isPreview: Bool = false

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
        // 전체를 감싸는 VStack (수직 중앙 정렬용)
        VStack(spacing: 0) {
            Spacer() // 상단 여백 밀어내기

            // 1. 라인과 캐릭터들이 노는 무대
            // 높이를 넉넉히(예: 60) 주어 캐릭터가 라인 위에 떠 있을 공간을 확보합니다.
            YearJourneyProgressLineView(
                progress: progress,
                theme: theme,
                isTintMode: isTintMode,
                isPreview: isPreview
            )
            .frame(height: 60) // 캐릭터(85)의 발 위치와 라인 높이를 고려한 적절한 높이 설정

            // 2. 하단 텍스트 (수평 중앙 정렬)
            if let text = displayText {
                Text(text)
                    .font(.custom("ComicRelief-Bold", size: 16))
                    .opacity(0.8)
                    .padding(.top, 4) // 라인과의 간격
                    .frame(maxWidth: .infinity) // 수평 중앙 정렬의 핵심
            }

            Spacer() // 하단 여백 밀어내기
        }
        .padding(16)
    }
}

// MARK: - 라인 및 캐릭터 뷰 (내용물)
struct YearJourneyProgressLineView: View {
    let progress: Double
    let theme: ThemeAssets
    let isTintMode: Bool
    var isPreview: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height

            // ------------------------------------------------======
            // [위치 및 크기 설정]
            // ------------------------------------------------======
            let goalSize: CGFloat = 40
            let goalHalf = goalSize / 2

            // 라인 길이: 전체 너비 - 골 이미지의 절반 (라인 끝 = 골 중앙)
            let lineWidth = width - goalHalf

            let clampedProgress = max(0.0, min(1.0, progress))
            let travelerX = lineWidth * clampedProgress

            // 1. 기준선 잡기 (라인의 중앙)
            let baseY = height - 14

            // 2. 라인 상단 좌표 구하기 (여기가 땅바닥!)
            // 라인 두께가 8이므로, 중앙에서 4만큼 위로 올린 지점이 'Top'입니다.
            let lineThickness: CGFloat = 8
            let lineTopY = baseY - (lineThickness / 2)

            let companionSize: CGFloat = 85

            // 3. 동반자 높이 보정 (발바닥 위치 맞추기)
            // "4x4 그리드 중 하단 1/4 지점이 발" -> 즉, 위에서 75% 지점이 발바닥
            let footRatio: CGFloat = 0.75 // 3/4 지점
            // 이미지 센터(0.5)에서 발바닥(0.75)까지의 거리
            let centerToFootDistance = companionSize * (footRatio - 0.5)

            // 4. 골 이미지 높이 보정 (바닥 맞추기)
            // 이미지 센터(0.5)에서 바닥(1.0)까지의 거리 = 높이의 절반
            let centerToBottomDistance = goalSize / 2


            let companionName = theme.companionImageName(isTintMode: isTintMode, fixIndex: isPreview ? 0 : nil)
            let goalName = isTintMode ? theme.goalTintImageName : theme.goalImageName
            let eraserImageName = isTintMode ? companionName.replacingOccurrences(of: "_tint", with: "") : ""

            // ------------------------------------------------======
            // [그리기 시작]
            // ------------------------------------------------======
            ZStack(alignment: .topLeading) {

                // [Layer 1] 라인 그룹 (라인은 baseY 기준 그대로 유지)
                ZStack(alignment: .leading) {
                    Capsule().frame(width: lineWidth, height: lineThickness).opacity(0.25)
                    Capsule().frame(width: travelerX, height: lineThickness)
                }
                .position(x: lineWidth / 2, y: baseY)
                .mask {
                    if isTintMode {
                        // 지우개도 동반자와 똑같은 높이로 올려서 지워야 함
                         ZStack {
                            Rectangle().fill(Color.white)
                            Image(eraserImageName)
                                .resizable().scaledToFit()
                                .frame(width: companionSize, height: companionSize)
                                .position(
                                    x: travelerX,
                                    y: lineTopY - centerToFootDistance // [변경] 라인 상단 기준 배치
                                )
                                .blendMode(.destinationOut)
                        }.compositingGroup()
                    } else {
                        Rectangle().fill(Color.white)
                    }
                }

                // [Layer 2] 목표물 이미지
                Image(goalName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: goalSize, height: goalSize)
                    .position(
                        x: lineWidth,
                        // [변경] 골 바닥이 라인 상단(lineTopY)에 닿도록 배치
                        // (센터 좌표 = 라인상단 - 절반높이)
                        y: lineTopY - centerToBottomDistance
                    )

                // [Layer 3] 동반자 이미지
                Image(companionName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: companionSize, height: companionSize)
                    .position(
                        x: travelerX,
                        // [변경] 발바닥이 라인 상단(lineTopY)에 닿도록 배치
                        // (센터 좌표 = 라인상단 - 센터에서발까지거리)
                        y: lineTopY - centerToFootDistance
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
