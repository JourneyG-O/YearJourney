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
            Section("Membership") {
                // ✅ [수정] if-else 분기를 없애고, 하나의 버튼으로 통합했습니다.
                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 16) {
                        // 1. 티켓 이미지 교체 로직
                        // 구매 전: img_ticket_mini_gray (회색)
                        // 구매 후: img_ticket_mini_gold (황금색)
                        Image(storeManager.isPurchased ? "ticket_mini_gold" : "ticket_mini_gray")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60) // 리스트 내부 크기 최적화
                            // 황금 티켓일 때만 살짝 빛나는 효과
                            .shadow(color: storeManager.isPurchased ? .orange.opacity(0.3) : .clear, radius: 4)

                        // 2. 텍스트 변경 로직
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Journey Pass")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            // 구매 여부에 따라 문구와 색상 변경
                            Text(storeManager.isPurchased ? "Premium Active" : "Unlock all companions")
                                .font(.caption)
                                .foregroundStyle(storeManager.isPurchased ? .orange : .secondary)
                                .fontWeight(storeManager.isPurchased ? .semibold : .regular)
                        }

                        Spacer()

                        // 3. 화살표는 '구매 전'에만 표시 (누를 수 있다는 힌트)
                        if !storeManager.isPurchased {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                // ✅ [핵심] 구매 완료 상태면 버튼 비활성화 (클릭해도 반응 없음)
                .disabled(storeManager.isPurchased)

                // 4. 구매 복원 버튼 (가운데 정렬 스타일 유지)
                Button {
                    Task {
                        await storeManager.updateCustomerProductStatus()
                    }
                } label: {
                    Text("Restore Purchases")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
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
