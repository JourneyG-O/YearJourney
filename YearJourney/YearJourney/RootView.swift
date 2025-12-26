//
//  RootView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Today")
                }

            ThemesView()
                .tabItem {
                    Image(systemName: "face.smiling")
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
    }
}

#Preview {
    RootView()
}
