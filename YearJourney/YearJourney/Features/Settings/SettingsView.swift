//
//  SettingsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

    // 📡 StoreManager 연결
    @ObservedObject private var storeManager = StoreManager.shared

    // 팝업 및 상태 관리 변수
    @State private var showPaywall = false
    @State private var isRestoring = false      // 복원 진행 중인지 여부
    @State private var showRestoreAlert = false // 복원 결과 알림창 표시 여부

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
            // 🎫 결제 화면(Paywall) 띄우기
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .presentationDetents([.fraction(0.65), .large]) // 살짝 작게 시작해서 크게 확장 가능
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(24)
            }
            // 🔔 [추가] 복원 결과 알림창
            .alert("구매 복원 확인", isPresented: $showRestoreAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                if storeManager.isPurchased {
                    Text("구매 내역이 성공적으로 복원되었습니다.\n모든 혜택이 다시 활성화됩니다.")
                } else {
                    Text("복원할 구매 내역을 찾지 못했습니다.\n구매하신 적이 있다면 동일한 Apple ID로 로그인되어 있는지 확인해주세요.")
                }
            }
        }
    }

    // 상단 헤더 타이틀
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

    // 1. 멤버십 섹션 (티켓 + 복원 버튼)
    private var purchasesSection: some View {
        Section {
            // 메인 티켓 버튼
            Button {
                showPaywall = true
            } label: {
                HStack(spacing: 16) {
                    // 티켓 이미지 (상태에 따라 변경)
                    Image(storeManager.isPurchased ? "ticket_mini_gold" : "ticket_mini_gray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        // 구매 완료 시 금색 빛 효과
                        .shadow(color: storeManager.isPurchased ? .orange.opacity(0.3) : .clear, radius: 4)

                    // 텍스트 정보
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Journey Pass")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        // 상태 문구
                        Text(storeManager.isPurchased ? "Premium Active" : "Unlock all companions")
                            .font(.caption)
                            .foregroundStyle(storeManager.isPurchased ? .orange : .secondary)
                            .fontWeight(storeManager.isPurchased ? .semibold : .regular)
                    }

                    Spacer()

                    // 화살표 (구매 전일 때만)
                    if !storeManager.isPurchased {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.vertical, 4)
            }
            // 구매 완료시 버튼 비활성화 (Paywall 진입 방지)
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
                HStack(spacing: 4) { // 아이콘과 텍스트 사이 간격 좁게 (8 -> 4)
                    if isRestoring {
                        // 로딩 중일 때는 인디케이터
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        // [추가] 평소에는 새로고침 아이콘
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

    // 2. 앱 정보 섹션
    private var appSection: some View {
        Section("App") {
            HStack {
                Label("Version", systemImage: "info.circle")
                Spacer()
                Text(AppVersionText.value)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // 3. 법적 고지 섹션
    var legalSection: some View {
            Section("Legal") {
                // ✅ TermsOfUseView 연결
                NavigationLink {
                    TermsOfUseView()
                } label: {
                    Label("Terms of Use", systemImage: "doc.text")
                }

                // ✅ PrivacyPolicyView 연결
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }

                // ✅ LicensesView 연결
                NavigationLink {
                    LicensesView()
                } label: {
                    Label("Licenses", systemImage: "text.book.closed")
                }
            }
        }
}

// 앱 버전 정보 가져오는 헬퍼
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
