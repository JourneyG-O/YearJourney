//
//  CircleCompanionPlaceholder.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/21/25.
//

import SwiftUI

struct CircleCompanionPlaceholder: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)

            Text("🐈")
                .font(.system(size: 64))
        }
    }
}

#Preview {
    CircleCompanionPlaceholder()
}
