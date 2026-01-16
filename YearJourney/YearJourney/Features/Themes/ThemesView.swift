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

    // 결제 뷰(ProUpdradeView)를 띄우기 위한 상태
    @State private var showProUpgradeSheet = false

    var body: some View {
        VStack(spacing: 8) {
            header

            List {
                ForEach(ThemeCatalog.all) { theme in
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
                                // 소유 안 했으면 -> "Pro 버전 구매하세요" 팝업
                                showProUpgradeSheet = true
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
        // 여기에 결제 유도 시트 연결
        .sheet(isPresented: $showProUpgradeSheet) {
            // 나중에 만들 ProUpgradeView (지금은 임시 텍스트)
            VStack(spacing: 20) {
                Text("Upgrade to Pro!")
                    .font(.largeTitle)
                Text("Unlock all future themes for just ₩5,500")
                Button("Purchase Lifetime Pass") {
                    entitlementStore.purchasePro()
                    showProUpgradeSheet = false
                }
                .buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium])
        }
    }

    private var header: some View {
        HStack {
            Text("Companions")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()

            // (선택) 헤더에도 Pro 구매 버튼 하나 두면 좋습니다
            if !entitlementStore.isProUser {
                Button("Pro") {
                    showProUpgradeSheet = true
                }
                .font(.custom("ComicRelief-Bold", size: 16))
                .foregroundStyle(.pink)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}
