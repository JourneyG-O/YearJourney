//
//  LicensesView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/27/25.
//

import SwiftUI

struct LicensesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                licenseSection(
                    title: "Comic Relief Font",
                    body: """
                    Comic Relief font is licensed under the SIL Open Font License.
                    © The Comic Relief Project Authors.
                    """
                )

                Divider()

                licenseSection(
                    title: "App Assets",
                    body: """
                    All illustrations and visual assets are original works
                    created for Year Journey.
                    """
                )

                Spacer(minLength: 24)
            }
            .padding(20)
        }
        .navigationTitle("Licenses")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func licenseSection(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Text(body)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
