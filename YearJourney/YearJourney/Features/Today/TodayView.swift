//
//  JourneyView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Data

    private var info: YearProgressInfo {
        ProgressCalculator.yearProgress()
    }

    private var remainingDays: Int {
        max(0, info.totalDaysInYear - info.dayOfYear)
    }

    // MARK: - Style

    private var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(red: 0.12, green: 0.12, blue: 0.13)
        } else {
            return Color(.systemGroupedBackground)
        }
    }

    // MARK: - Layout Tokens

    private enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
    }

    private enum Metrics {
        static let titleSize: CGFloat = 30
        static let progressBarHorizontalPadding: CGFloat = 36
        static let companionHorizontalPadding: CGFloat = 30

        static let progressInfoTopPadding: CGFloat = 8
        static let dDayTopPadding: CGFloat = 22

        static let progressInfoFontSize: CGFloat = 18
        static let dDayFontSize: CGFloat = 36
        static let dDayTracking: CGFloat = 1.0
    }

    var body: some View {
        VStack {
            header

            Spacer(minLength: 0)

            companionView
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, Metrics.companionHorizontalPadding)

            Spacer(minLength: 0)
            

            YearProgressBarView(progress: info.progress)
                .padding(.horizontal, Metrics.progressBarHorizontalPadding)
                .padding(.bottom, Spacing.s)

            progressInfoSection
                .padding(.top, Metrics.progressInfoTopPadding)

            Spacer()
        }
        .background(backgroundColor)
    }

    // MARK: - Sections

    private var header: some View {
        HStack {
            Text("Today")
                .font(.custom("ComicRelief-Bold", size: Metrics.titleSize))
            Spacer()

            Text(Date.now, format: .dateTime.month(.abbreviated).day())
                .font(.custom("ComicRelief-Bold", size: 14))
                .opacity(0.6)
        }
        .padding(.horizontal, Spacing.m)
        .padding(.top, Spacing.s)
    }

    private var progressInfoSection: some View {
        VStack(spacing: 0) {
            Text("\(info.dayOfYear) / \(info.totalDaysInYear)")
                .font(.custom("ComicRelief-Bold", size: Metrics.progressInfoFontSize))
                .opacity(0.85)
        }
    }

    // D-Day는 보류
    private var dDaySection: some View {
        VStack(spacing: 0) {
            Text("D-\(remainingDays)")
                .font(.custom("ComicRelief-Bold", size: Metrics.dDayFontSize))
                .tracking(Metrics.dDayTracking)
                .opacity(0.85)
        }
    }

    // MARK: - Companion

    private var companionView: some View {
        GeometryReader { geo in
            let side = geo.size.width
            let theme = themeManager.currentTheme
            let companionName = theme.mainImageName

            Image(companionName)
                .resizable()
                .scaledToFit()
                .frame(width: side, height: side)
                .frame(width: side, height: side)
        }
    }
}

#Preview {
    TodayView()
}
