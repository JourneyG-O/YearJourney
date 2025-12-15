//
//  YearProgressBarView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/12/25.
//

import SwiftUI

struct YearProgressBarView: View {
    let progress: Double

    private let barHeight: CGFloat = 20
    private let cornerRadius: CGFloat = 999

    var body: some View {
        let clamped = max(0.0, min(1.0, progress))

        GeometryReader { proxy in
            let width = proxy.size.width

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(height: barHeight)
                    .opacity(0.2)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: width * CGFloat(clamped), height: barHeight)
            }
        }
        .frame(height: barHeight)
    }
}
