//
//  YearJourneyMediumWidgetView.swift
//  YearJourney
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
    let config: WidgetConfig
    let isTintMode: Bool
    var isPreview: Bool = false

    // MARK: - Computed Properties

    private var displayText: String? {
        switch config.displayMode {
        case .dayFraction:
            return "\(dayOfYear) / \(totalDaysInYear)"
        case .percent:
            return "\(Int(progress * 100))%"
        case .dRemaining:
            return "D-\(totalDaysInYear - dayOfYear)"
        case .off:
            return nil
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            YearJourneyProgressLineView(
                progress: progress,
                theme: theme,
                isTintMode: isTintMode,
                isPreview: isPreview
            )
            .frame(height: 60)

            if let text = displayText {
                Text(text)
                    .font(.custom("ComicRelief-Bold", size: 16))
                    .opacity(0.8)
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity)
            }

            Spacer()
        }
        .padding(16)
    }
}

// MARK: - WidgetKit compatibility shim
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
