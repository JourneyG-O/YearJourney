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
            JourneyView()
                .tabItem {
                    Image(systemName: "circle")
                    Text("Journey")
                }

            ThemesView()
                .tabItem {
                    Image(systemName: "paintpalette")
                    Text("Themes")
                }

            WidgetsView()
                .tabItem {
                    Image(systemName: "rectangle")
                    Text("Widgets")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    RootView()
}
