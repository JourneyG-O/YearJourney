//
//  TermsOfUseView.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/6/26.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                section(
                    title: "Terms of Use",
                    body: """
                    Effective Date: October 29, 2025

                    These Terms of Use (“Terms”) govern your use of the Year Journey mobile application (“App”) operated by Stannum.

                    By using the App, you agree to these Terms.
                    """
                )

                Divider()

                section(
                    title: "Service Description",
                    body: """
                    Year Journey is a personal progress visualization app that helps you track the passage of time and milestones.

                    The App stores data locally on your device and does not require account registration or server synchronization.
                    """
                )

                Divider()

                section(
                    title: "In-App Purchases",
                    body: """
                    The App may offer optional in-app purchases to unlock additional themes or features.

                    All payments are processed through your Apple ID via the App Store.
                    Previously purchased items can be restored using Apple’s restore functionality.
                    """
                )

                Divider()

                section(
                    title: "Intellectual Property",
                    body: """
                    All content, design, and assets in the App are owned by Stannum or its licensors.

                    You may not copy, modify, or redistribute any part of the App without permission.
                    """
                )

                Divider()

                section(
                    title: "Disclaimer",
                    body: """
                    The App is provided “as is” without warranties of any kind.

                    Stannum shall not be liable for any damages arising from the use or inability to use the App.
                    """
                )

                Divider()

                section(
                    title: "Contact",
                    body: """
                    If you have questions about these Terms, please contact:

                    Email: contact@stannum.app
                    """
                )

                Spacer(minLength: 24)
            }
            .padding(20)
        }
        .navigationTitle("Terms of Use")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func section(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Text(body)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
