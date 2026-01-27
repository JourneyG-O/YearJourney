//
//  SettingsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

    // 📡 구매 상태 확인 및 팝업 제어
    @ObservedObject private var storeManager = StoreManager.shared
    @State private var showPaywall = false

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
            // 🎫 구매 화면 띄우기
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .presentationDetents([.fraction(0.65), .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(24)
            }
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
        Section("Membership") { // 섹션 이름을 Purchases -> Membership으로 변경 추천

            // 1. 구매 상태에 따른 분기 처리
            if !storeManager.isPurchased {
                // 🔒 아직 안 산 경우: 구매 유도 배너
                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 12) {
                        // 모카 포니 아이콘
                        Image("pony_mocha_main")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.accentColor.opacity(0.3), lineWidth: 1))
                            .padding(.vertical, 4)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Journey Pass")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text("Unlock all companions")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            } else {
                // ✅ 이미 산 경우: Pro 배지 표시
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.accentColor)
                        .font(.title2)

                    VStack(alignment: .leading) {
                        Text("Journey Pass Active")
                            .font(.headline)
                        Text("Thank you for your support!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            // 2. 구매 복원 버튼 (기존 NavigationLink 대신 동작 버튼으로 변경)
            // 구매 전이든 후든 복원 버튼은 있는 게 안전합니다.
            Button {
                Task {
                    await storeManager.updateCustomerProductStatus()
                }
            } label: {
                Label("Restore Purchases", systemImage: "arrow.clockwise")
                    .foregroundStyle(.primary) // 링크 색상 대신 기본색 사용
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
            NavigationLink {
                // TermsOfUseView()
            } label: {
                Label("Terms of Use", systemImage: "doc.text")
            }

            NavigationLink {
                // PrivacyPolicyView()
            } label: {
                Label("Privacy Policy", systemImage: "hand.raised")
            }

            NavigationLink {
                // LicensesView()
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
