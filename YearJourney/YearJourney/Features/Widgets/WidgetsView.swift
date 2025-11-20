//
//  WidgetsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct WidgetsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Medium Widget") {
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 60)
                            .opacity(0.2)
                        Text("Year Journey Widget")
                            .font(.subheadline)
                    }
                }

                Section("Small Widgets") {
                    Text("Goal Fill Widget")
                    Text("Month Progress Widget")
                }
            }
            .navigationTitle("Widgets")
        }
    }
}

#Preview {
    WidgetsView()
}
