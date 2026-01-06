//
//  SettingsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                header

                List {
                    purchasesSection
                    appSection
                    legalSection
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    private var header: some View {
        HStack {
            Text("About")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

private extension SettingsView {

    private var purchasesSection: some View {
        Section("Purchases") {
            NavigationLink {
                //                RestorePurchasesView()
            } label : {
                Label("Restore Purchases", systemImage: "arrow.clockwise")
            }
        }
    }

    private var appSection: some View {
        Section("App") {
            HStack {
                Label("version", systemImage: "info.circle")
                Spacer()
                Text(AppVersionText.value)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var legalSection: some View {
        Section("Legal") {
            Button {
                openURL(URL(string: "https://stannum.app/apps/year-journey/legal/terms.html")!)
            } label: {
                Label("Terms of Use", systemImage: "doc.text")
            }

            Button {
                openURL(URL(string: "https://stannum.app/apps/year-journey/legal/privacy.html")!)
            } label: {
                Label("Privacy Policy", systemImage: "hand.raised")
            }

            NavigationLink {
                LicensesView()
            } label: {
                Label("Licenses", systemImage: "text.book.closed")
            }
        }
    }
}

enum AppVersionText {
    static var value: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (\(build))"
    }
}

#Preview {
    SettingsView()
}
