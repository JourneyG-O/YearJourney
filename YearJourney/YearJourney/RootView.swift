//
//  RootView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct RootView: View {

    @Environment(\.colorScheme) var colorScheme

    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
    }

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Today")
                }

            ThemesView()
                .tabItem {
                    Image(systemName: colorScheme == .dark ? "face.smiling" : "face.smiling.inverse")
                    Text("Companions")
                }

            WidgetsView()
                .tabItem {
                    Image(systemName: "rectangle.fill.on.rectangle.fill")
                    Text("Widgets")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .tint(.primary)
    }
}

#Preview {
    RootView()
}
