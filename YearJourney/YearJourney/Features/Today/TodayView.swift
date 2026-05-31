//
//  TodayView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    @State private var activeDayEvent: ActiveDayEvent? = nil

    // MARK: - Data

    private var info: YearProgressInfo {
        ProgressCalculator.yearProgress()
    }

    private var companionName: String {
        themeManager.currentTheme.displayName
    }

    // MARK: - Style

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.12, green: 0.12, blue: 0.13)
            : Color(.systemGroupedBackground)
    }

    // MARK: - Layout Tokens

    private enum Spacing {
        static let s: CGFloat = 8
        static let m: CGFloat = 16
    }

    private enum Metrics {
        static let titleSize: CGFloat = 30
        static let progressBarHorizontalPadding: CGFloat = 36
        static let companionHorizontalPadding: CGFloat = 30
        static let progressInfoTopPadding: CGFloat = 8
        static let progressInfoFontSize: CGFloat = 18
        static let companionNameSize: CGFloat = 24
    }

    // MARK: - Body

    var body: some View {
        VStack {
            header

            Spacer(minLength: 0)

            companionView
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, Metrics.companionHorizontalPadding)
                .overlay(alignment: .bottom) {
                    Text(companionName)
                        .font(.custom("ComicRelief-Bold", size: Metrics.companionNameSize))
                        .foregroundColor(.primary)
                        .opacity(0.9)
                        .offset(y: -20)
                }
                .overlay(alignment: .topTrailing) {
                    if let active = activeDayEvent {
                        DayEventBubbleView(activeEvent: active)
                            .padding(.trailing, -8)
                            .padding(.top, 8)
                    }
                }

            Spacer(minLength: 0)

            YearProgressBarView(progress: info.progress)
                .padding(.horizontal, Metrics.progressBarHorizontalPadding)
                .padding(.bottom, Spacing.s)

            progressInfoSection
                .padding(.top, Metrics.progressInfoTopPadding)

            Spacer()
        }
        .background(backgroundColor)
        .onAppear { reloadDayEvent() }
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
        Text("\(info.dayOfYear) / \(info.totalDaysInYear)")
            .font(.custom("ComicRelief-Bold", size: Metrics.progressInfoFontSize))
            .opacity(0.85)
    }

    // MARK: - Companion

    private var companionView: some View {
        GeometryReader { geo in
            let side = geo.size.width
            Image(themeManager.currentTheme.mainImageName)
                .resizable()
                .scaledToFit()
                .frame(width: side, height: side)
        }
    }

    // MARK: - Methods

    private func reloadDayEvent() {
        let events = DayEventStore.load()
        activeDayEvent = DayEventCalculator.activeEvent(from: events)
    }
}

#Preview {
    TodayView()
        .environmentObject(ThemeManager.shared)
}
