//
//  TemesView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct ThemesView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var entitlementStore = ThemeEntitlementStore.shared
    @ObservedObject private var storeManager = StoreManager.shared

    // 결제 뷰(ProUpgradeView)를 띄우기 위한 상태
    @State private var showPaywall = false

    var body: some View {
        VStack(spacing: 8) {
            header

            List {
                ForEach(ThemeCatalog.all) { theme in
                    // StoreManager와 연결된 entitlementStore가 진짜 권한을 확인합니다.
                    let isOwned = entitlementStore.isOwned(theme)

                    ThemeRow(
                        theme: theme,
                        isSelected: theme.id == themeManager.currentTheme.id,
                        isOwned: isOwned,
                        onSelect: {
                            if isOwned {
                                // 소유했으면 바로 적용
                                themeManager.selectTheme(theme)
                            } else {
                                // 소유 안 했으면 -> "Pro 버전 구매하세요" 팝업 띄우기
                                showPaywall = true
                            }
                        }
                    )
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .background(Color(.systemGroupedBackground))
        // ✅ 진짜 결제 화면 연결!
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .presentationDetents([.fraction(0.65), .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
    }

    private var header: some View {
        HStack {
            Text("Companions")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()

            Button {
                showPaywall = true
            } label: {
                Image(storeManager.isPurchased ? "ticket_mini_gold" : "ticket_mini_gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .shadow(color: storeManager.isPurchased ? .orange.opacity(0.4) : .clear, radius: 5)
            }
            .disabled(storeManager.isPurchased)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}
