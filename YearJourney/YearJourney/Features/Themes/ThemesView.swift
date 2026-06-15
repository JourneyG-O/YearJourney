//
//  TemesView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct ThemesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var storeManager: StoreManager
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.12, green: 0.12, blue: 0.13)
            : Color(.systemGroupedBackground)
    }

    // 결제 뷰(ProUpgradeView)를 띄우기 위한 상태
    @State private var showPaywall = false

    // 타이밍 테마 이벤트 활성 중에는 테마 변경 불가
    private var isBoxEventActive: Bool {
        if let event = TimedThemeEvent.all.first(where: { $0.themeID == themeManager.currentTheme.themeID }) {
            return !TimedThemeEventManager.isShown(event)
        }
        return false
    }

    var body: some View {
        VStack(spacing: 8) {
            header

            if isBoxEventActive {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.secondary)
                    Text("A new update is waiting for you!")
                        .font(.custom("ComicRelief-Bold", size: 16))
                    Text("Open the app to discover what's new.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding()
                Spacer()
            } else {
            List {
                ForEach(ThemeCatalog.all) { theme in
                    // StoreManager와 연결된 entitlementStore가 진짜 권한을 확인합니다.
                    let isOwned = !theme.isPremium || storeManager.isPurchased

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
            } // end else
        }
        .background(backgroundColor)
        // ✅ 진짜 결제 화면 연결!
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .presentationDetents([.large])
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
                    .frame(width: 60)
                    .shadow(color: storeManager.isPurchased ? .orange.opacity(0.4) : .clear, radius: 5)
            }
            .disabled(storeManager.isPurchased)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}
