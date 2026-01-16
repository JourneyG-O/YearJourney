//
//  ThemeRow.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/16/25.
//

import SwiftUI

struct ThemeRow: View {
    @Environment(\.colorScheme) var colorScheme

    let theme: ThemeAssets
    let isSelected: Bool
    let isOwned: Bool

    // 개별 가격 정보 필요 없음
    // let priceText: String?

    let onSelect: () -> Void
    // 개별 구매 액션 대신, 잠긴 걸 눌렀을 때의 액션(Pro 팝업 띄우기)으로 통합됨

    var body: some View {
        let background = rowBackground(isSelected: isSelected)

        HStack(spacing: 12) {
            previewIcons
                .layoutPriority(1) // 이미지들이 찌그러지지 않게 우선순위 높임

            Text(theme.displayName)
                .font(.custom("ComicRelief-Bold", size: 18))
                .lineLimit(1)
                .layoutPriority(1) // 텍스트도 중요

            Spacer()

            trailingView
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) // 터치 영역 확보
        .onTapGesture {
            // 소유했으면 선택, 아니면 구매 팝업(상위 뷰에서 처리)
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
                // 소유 안 했으면 살짝 흐리게 처리해서 '잠김' 느낌 주기
                .opacity(isOwned ? 1.0 : 0.6)
                .grayscale(isOwned ? 0 : 1.0) // (선택) 소유 안 하면 흑백 처리도 좋음

            Text("+")
                .font(.system(size: 16, weight: .semibold))
                .opacity(0.6)

            Image(goal)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .opacity(isOwned ? 1.0 : 0.6)
                .grayscale(isOwned ? 0 : 1.0)
        }
    }

    @ViewBuilder
        private var trailingView: some View {
            if isOwned {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .foregroundStyle(Color.primary.opacity(0.9))
                } else {
                    EmptyView()
                }
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
            }
        }

    private func rowBackground(isSelected: Bool) -> Color {
        if isSelected {
            return colorScheme == .light ? Color.white : Color(.secondarySystemBackground)
        } else {
            return Color.clear
        }
    }
}
