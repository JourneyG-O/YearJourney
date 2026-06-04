//
//  SettingsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var storeManager: StoreManager

    @State private var showPaywall = false
    @State private var isRestoring = false
    @State private var showRestoreAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                header

                List {
                    purchasesSection
                    appSection
                    legalSection
                    #if DEBUG
                    debugSection
                    #endif
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .presentationDetents([.fraction(0.65), .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(24)
            }
            .alert("Restore Purchase", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                if storeManager.isPurchased {
                    Text("Your purchase has been restored successfully.")
                } else {
                    Text("No previous purchase found.\nMake sure you're signed in with the same Apple ID used for the original purchase.")
                }
            }
        }
    }

    // MARK: - Sections

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

// MARK: - Sections
private extension SettingsView {

    var purchasesSection: some View {
        Section {
            Button {
                showPaywall = true
            } label: {
                HStack(spacing: 16) {
                    Image(storeManager.isPurchased ? "ticket_mini_gold" : "ticket_mini_gray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .shadow(color: storeManager.isPurchased ? .orange.opacity(0.3) : .clear, radius: 4)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Journey Pass")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(storeManager.isPurchased ? "Premium Active" : "Unlock all companions")
                            .font(.caption)
                            .foregroundStyle(storeManager.isPurchased ? .orange : .secondary)
                            .fontWeight(storeManager.isPurchased ? .semibold : .regular)
                    }

                    Spacer()

                    if !storeManager.isPurchased {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.vertical, 4)
            }
            .disabled(storeManager.isPurchased)

        } header: {
            Text("Membership")
        } footer: {
            Button {
                Task {
                    isRestoring = true
                    await storeManager.updateCustomerProductStatus()
                    isRestoring = false
                    showRestoreAlert = true
                }
            } label: {
                HStack(spacing: 4) {
                    if isRestoring {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                    Text(isRestoring ? "Checking..." : "Restore Purchases")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
            }
            .disabled(isRestoring)
        }
    }

    var appSection: some View {
        Section("App") {
            HStack {
                Label("Version", systemImage: "info.circle")
                Spacer()
                Text(AppVersion.string)
                    .foregroundStyle(.secondary)
            }
        }
    }

    #if DEBUG
    var debugSection: some View {
        Section("Debug") {
            Button("Reset Box Event") {
                AppGroupStore.defaults.removeObject(forKey: WidgetKeys.boxEventShown)
                AppGroupStore.defaults.removeObject(forKey: WidgetKeys.boxEventVersion)
                AppGroupStore.defaults.removeObject(forKey: WidgetKeys.boxEventOriginalThemeID)
            }
            .foregroundStyle(.orange)
        }
    }
    #endif

    var legalSection: some View {
        Section("Legal") {
            NavigationLink {
                TermsOfUseView()
            } label: {
                Label("Terms of Use", systemImage: "doc.text")
            }

            NavigationLink {
                PrivacyPolicyView()
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

// MARK: - Helpers
private enum AppVersion {
    static var string: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (\(build))"
    }
}

#Preview {
    SettingsView()
        .environmentObject(StoreManager.shared)
}
