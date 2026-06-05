//
//  RootView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct RootView: View {

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var dayEventManager: DayEventManager
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var deepLinkEvent: DayEvent? = nil
    @State private var showBoxOnboarding = false
    @State private var selectedTab = 0
    @AppStorage("showDayTabBadge") private var showDayTabBadge = false

    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Today")
                }
                .tag(0)

            ThemesView()
                .tabItem {
                    Image(systemName: colorScheme == .dark ? "face.smiling" : "face.smiling.inverse")
                    Text("Companions")
                }
                .tag(1)

            DayEventListView()
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("D-Day")
                }
                .badge(showDayTabBadge ? "" : nil)
                .tag(2)

            WidgetsView()
                .tabItem {
                    Image(systemName: "rectangle.fill.on.rectangle.fill")
                    Text("Widgets")
                }
                .tag(3)
        }
        .onChange(of: selectedTab) { _, tab in
            if tab == 2 { showDayTabBadge = false }
        }
        .tint(.primary)
        .onAppear { checkBoxOnboarding() }
        .onChange(of: themeManager.currentTheme.themeID) { _, _ in checkBoxOnboarding() }
        .onOpenURL { url in handleDeepLink(url) }
        .sheet(item: $deepLinkEvent) { event in
            DayEventFormView(editing: event)
        }
        .fullScreenCover(isPresented: $showBoxOnboarding) {
            BoxEventOnboardingView()
        }
    }

    // MARK: - Box Onboarding

    private func checkBoxOnboarding() {
        if themeManager.currentTheme.themeID == .boxCat && !BoxEventManager.isBoxEventShown {
            showBoxOnboarding = true
        }
    }

    // MARK: - Deep Link

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "yearjourney" else { return }

        // yearjourney://box-event
        if url.host == "box-event" {
            if !BoxEventManager.isBoxEventShown {
                showBoxOnboarding = true
            }
            return
        }

        // yearjourney://dday/{eventId}
        guard url.host == "dday",
              let uuidString = url.pathComponents.last,
              let uuid = UUID(uuidString: uuidString),
              let event = dayEventManager.events.first(where: { $0.id == uuid })
        else { return }
        deepLinkEvent = event
    }
}

#Preview {
    RootView()
}
