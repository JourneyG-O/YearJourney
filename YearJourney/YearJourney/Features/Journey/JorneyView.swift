//
//  JourneyView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct JourneyView: View {

    private let dummyDate = Date()
    private let dummyProgress: Double = 0.32
    private let dummyDayOfYear: Int = 45

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            // 1) 동반자
            CircleCompanionPlaceholder()
                .frame(width: 300, height: 300)

            // 2) 날짜
            Text("\(dummyDayOfYear) / 365")
                .font(.largeTitle)

            Spacer()
        }
    }
}

#Preview {
    JourneyView()
}
