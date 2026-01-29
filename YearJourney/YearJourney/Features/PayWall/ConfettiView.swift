//
//  ConfettiView.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/29/26.
//

import SwiftUI

struct ConfettiView: View {
    @State private var isAnimating = false
    let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]

    var body: some View {
        ZStack {
            ForEach(0..<50) { _ in
                Circle()
                    .fill(colors.randomElement()!)
                    .frame(width: CGFloat.random(in: 5...10))
                    .offset(x: CGFloat.random(in: -200...200), y: CGFloat.random(in: -300...300))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .scaleEffect(isAnimating ? 1.0 : 0.1)
                    .opacity(isAnimating ? 0 : 1)
                    .animation(
                        .easeOut(duration: Double.random(in: 1.0...2.5))
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
