//
//  SmallWidgetSettingsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import SwiftUI
import YearJourneyShared

struct SmallWidgetSettingsView: View {

    var body: some View {
        VStack(spacing: 12) {
            Text("Small Widget Settings")
                .font(.custom("ComicRelief-Bold", size: 24))

            Text("Coming soon")
                .font(.custom("ComicRelief-Regular", size: 16))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(16)
        .navigationTitle("Small")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        SmallWidgetSettingsView()
    }
}
