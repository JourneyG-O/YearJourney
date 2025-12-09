//
//  JourneyView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct JourneyView: View {

    private var yearInfo: YearProgressInfo {
        ProgressCalculator.yearProgress()
    }

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            // 1) 동반자
            CircleCompanionPlaceholder()
                .frame(width: 300, height: 300)

            // 2) 날짜
            Text("\(yearInfo.dayOfYear) / \(yearInfo.totalDaysInYear)")
                .font(.largeTitle)

            Spacer()
        }
    }
}

#Preview {
    JourneyView()
}
