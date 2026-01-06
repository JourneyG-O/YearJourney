//
//  PrivacyPolicyView.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/6/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                section(
                    title: "Privacy Policy",
                    body: """
                    Effective Date: October 29, 2025

                    Your privacy is important to us.
                    This Privacy Policy explains how Year Journey handles your information.
                    """
                )

                Divider()

                section(
                    title: "Information We Collect",
                    body: """
                    Year Journey does not collect personal information.

                    All app data is stored locally on your device using system storage such as UserDefaults.
                    """
                )

                Divider()

                section(
                    title: "Third-Party Services",
                    body: """
                    The App does not use third-party analytics, advertising, or tracking SDKs.

                    In-app purchases are handled by Apple and subject to Apple’s privacy policies.
                    """
                )

                Divider()

                section(
                    title: "Data Security",
                    body: """
                    Since no personal data is transmitted or stored on external servers, the risk of data leakage is minimized.

                    However, no system can be guaranteed to be 100% secure.
                    """
                )

                Divider()

                section(
                    title: "Changes to This Policy",
                    body: """
                    This Privacy Policy may be updated from time to time.

                    Any changes will be reflected within the App.
                    """
                )

                Divider()

                section(
                    title: "Contact",
                    body: """
                    If you have questions about this Privacy Policy, please contact:

                    Email: contact@stannum.app
                    """
                )

                Spacer(minLength: 24)
            }
            .padding(20)
        }
        .navigationTitle("Privacy Policy")
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
