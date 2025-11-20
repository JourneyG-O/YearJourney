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
            Text("Journey")
                .tabItem {
                    Image(systemName: "circle")
                    Text("Journey")
                }

            Text("Themes")
                .tabItem {
                    Image(systemName: "paintpalette")
                    Text("Themes")
                }

            Text("Widgets")
                .tabItem {
                    Image(systemName: "rectangle")
                    Text("Widgets")
                }

            Text("Settings")
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
