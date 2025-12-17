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


    var body: some View {
        VStack(spacing: 8) {
            header

            List {
                ForEach(ThemeCatalog.all) { theme in
                    ThemeRow(
                        theme: theme,
                        isSelected: theme.id == themeManager.currentTheme.id,
                        isOwned: entitlementStore.isOwned(theme),
                        priceText: entitlementStore.priceText(for: theme),
                        onSelect: {
                            guard entitlementStore.isOwned(theme) else { return }
                            themeManager.selectTheme(theme)
                        },
                        onBuy: {
                            entitlementStore.purchase(theme)
                            themeManager.selectTheme(theme)
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
    }

    private var header: some View {
        HStack {
            Text("Companions")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

#Preview {
    ThemesView()
}
