//
//  JourneyView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct JourneyView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Journey")
                .font(.largeTitle)
                .padding(.top, 40)

            Circle()
                .frame(width: 150, height: 150)
                .overlay(Text("🐈"))

            Rectangle()
                .frame(height: 6)
                .padding(.horizontal, 40)
                .opacity(0.3)

            Text("Today: 2025-02-10")
                .font(.headline)

            Spacer()
        }
    }
}

#Preview {
    JourneyView()
}
