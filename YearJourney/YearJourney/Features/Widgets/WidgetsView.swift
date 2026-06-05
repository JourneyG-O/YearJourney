//
//  WidgetsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI
import WidgetKit

struct WidgetsView: View {

    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var dayEventManager: DayEventManager
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.12, green: 0.12, blue: 0.13)
            : Color(.systemGroupedBackground)
    }

    @State private var theme: ThemeAssets = ThemeCatalog.defaultTheme
    @State private var mediumConfig: WidgetConfig = WidgetConfig.defaultConfig(for: .medium)
    @State private var smallConfig: WidgetConfig = WidgetConfig.defaultConfig(for: .small)
    @State private var isSwaying = false

    private var yearInfo: YearProgressInfo { ProgressCalculator.yearProgress() }
    private var monthInfo: MonthProgressInfo { ProgressCalculator.monthProgress() }
    private var activeEvent: ActiveDayEvent? {
        mediumConfig.showDayEvent ? dayEventManager.activeEvent : nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                Spacer(minLength: 16)

                NavigationLink {
                    WidgetSettingsView(kind: .medium)
                } label: {
                    WidgetPreviewCard(title: "Medium", family: .systemMedium,
                                      widgetBackground: themeManager.currentTheme.previewBackground) {
                        YearJourneyMediumWidgetView(
                            progress: yearInfo.progress,
                            dayOfYear: yearInfo.dayOfYear,
                            totalDaysInYear: yearInfo.totalDaysInYear,
                            theme: themeManager.currentTheme,
                            config: mediumConfig,
                            isTintMode: false,
                            isPreview: true,
                            activeDayEvent: activeEvent
                        )
                        .padding(16)
                    }
                }
                .buttonStyle(.plain)
                .rotationEffect(.degrees(isSwaying ? 1.5 : -1.5), anchor: .bottom)

                Spacer(minLength: 16)

                NavigationLink {
                    WidgetSettingsView(kind: .small)
                } label: {
                    WidgetPreviewCard(title: "Small", family: .systemSmall,
                                      widgetBackground: themeManager.currentTheme.previewBackground) {
                        YearJourneySmallWidgetView(
                            fillProgress: monthInfo.progress,
                            dayOfMonth: monthInfo.dayOfMonth,
                            totalDaysInMonth: monthInfo.totalDaysInMonth,
                            theme: themeManager.currentTheme,
                            config: smallConfig,
                            isTintMode: false
                        )
                        .padding(16)
                    }
                }
                .buttonStyle(.plain)
                .rotationEffect(.degrees(isSwaying ? -1.5 : 1.5), anchor: .bottom)

                Spacer(minLength: 16)
            }
            .padding(.horizontal, 16)
            .background(backgroundColor)
            .onAppear {
                reloadPreviewState()
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isSwaying = true
                }
            }
        }
    }

    private func reloadPreviewState() {
        let savedThemeID = AppGroupStore.defaults.string(forKey: WidgetKeys.selectedThemeID)
        theme = ThemeCatalog.theme(for: savedThemeID)
        mediumConfig = WidgetConfig.load(for: .medium)
        smallConfig = WidgetConfig.load(for: .small)
    }

    private var header: some View {
        HStack {
            Text("Widgets")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }


}

/// 공통 카드 컨테이너 (탭에서 “실제 위젯처럼 보이는 카드”)
struct WidgetPreviewCard<Content: View>: View {
    let title: String
    let family: WidgetFamily
    var widgetBackground: AnyShapeStyle = AnyShapeStyle(Color(.secondarySystemGroupedBackground))
    @ViewBuilder let content: Content

    var body: some View {
        let widgetSize = WidgetPreviewSize.size(for: family)

        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.custom("ComicRelief-Bold", size: 16))
                .foregroundStyle(.secondary)

            content
                .frame(width: widgetSize.width, height: widgetSize.height)
                .environment(\.colorScheme, .light)
                .background(widgetBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center) // 가운데 정렬
    }
}

#Preview {
    WidgetsView()
}
