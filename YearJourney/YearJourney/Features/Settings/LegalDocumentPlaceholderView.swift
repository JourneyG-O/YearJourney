//
//  LegalDocumentPlaceholderView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/27/25.
//

import SwiftUI

struct LegalDocumentPlaceholderView: View {
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)

            Text("Placeholder.\nLater: open a WebView or show markdown text.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
