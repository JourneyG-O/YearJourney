//
//  RestorePurchasesView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/27/25.
//

import SwiftUI

struct RestorePurchasesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.clockwise.circle")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)

            Text("Restore Purchases")
                .font(.headline)

            Text("This is a placeholder screen.\nWe’ll connect StoreKit restore later.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("Restore")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { RestorePurchasesView() }
}
