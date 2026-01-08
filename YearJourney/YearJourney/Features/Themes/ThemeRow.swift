//
//  ThemeRow.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/16/25.
//

import SwiftUI

struct ThemeRow: View {
    let theme: ThemeAssets
    let isSelected: Bool
    let isOwned: Bool
    let priceText: String?

    let onSelect: () -> Void
    let onBuy: () -> Void

    var body: some View {
        let background = rowBackground(isSelected: isSelected)

        HStack(spacing: 12) {
            previewIcons

            Text(theme.displayName)
                .font(.custom("ComicRelief-Bold", size: 18))
                .lineLimit(1)

            Spacer()

            trailingView
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture {
            guard isOwned else { return }
            onSelect()
        }
    }

    private var previewIcons: some View {
        HStack(spacing: 8) {
            let companion = theme.mainImageName
            let goal = theme.goalImageName

            Image(companion)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .opacity(isOwned ? 1.0 : 0.85)

            Text("+")
                .font(.system(size: 16, weight: .semibold))
                .opacity(0.6)

            Image(goal)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .opacity(isOwned ? 1.0 : 0.85)
        }
    }

    @ViewBuilder
    private var trailingView: some View {
        if isSelected {
            Image(systemName: "checkmark")
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .foregroundStyle(Color.primary.opacity(0.9))
        } else if isOwned {
            EmptyView()
        } else {
            BuyButton(title: buyTitle, action: onBuy)
        }
    }

    private var buyTitle: String {
        if let priceText, !priceText.isEmpty {
            return "Buy \(priceText)"
        } else {
            return "Buy"
        }
    }

    private func rowBackground(isSelected: Bool) -> Color {
        if isSelected {
            return Color(.secondarySystemBackground)
        } else {
            return Color(.systemBackground)
        }
    }
}

private struct BuyButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("ComicRelief-Bold", size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
    }
}
