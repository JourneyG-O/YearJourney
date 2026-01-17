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

    // 결제 뷰(ProUpgradeView)를 띄우기 위한 상태
    @State private var showProUpgradeSheet = false

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
        // ✅ 진짜 결제 화면 연결!
        .sheet(isPresented: $showProUpgradeSheet) {
            ProUpgradeView() // 이제 임시 텍스트가 아니라 진짜 UI가 뜹니다.
        }
    }

    private var header: some View {
        HStack {
            Text("Companions")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()

            // (선택 사항) 헤더에 Pro 버튼을 작게 두는 것도 좋습니다.
            // 이미 샀으면 숨깁니다.
            if !StoreManager.shared.isPurchased {
                Button {
                    showProUpgradeSheet = true
                } label: {
                    Text("PRO")
                        .font(.custom("ComicRelief-Bold", size: 14))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}
