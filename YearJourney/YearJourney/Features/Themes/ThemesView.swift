//
//  TemesView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct ThemesView: View {
    @StateObject private var themeManager = ThemeManager.shared
//    @StateObject private var entitlementStore = ThemeEntitlementStore.shared


    var body: some View {
        NavigationStack {
            List {
                Section("Themes") {
                    Text("Minimal Cat")
                    Text("Dog & Bone")
                    Text("8bit Retro")
                }
            }
            .navigationTitle("Themes")
        }
    }
}

#Preview {
    ThemesView()
}
