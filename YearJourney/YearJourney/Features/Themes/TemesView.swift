//
//  TemesView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct TemesView: View {
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
    TemesView()
}
