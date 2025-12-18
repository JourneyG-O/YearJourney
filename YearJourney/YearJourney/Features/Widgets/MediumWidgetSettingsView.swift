//
//  MediumWidgetSettingsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import SwiftUI

struct MediumWidgetSettingsView: View {
    // TODO: 실제 저장/로드는 다음 커멧이서 연결
    @State private var draftConfig: MediumWidgetConfig = .default

    // 프리뷰용 더미 값 (나중에 실제 계산값/테마로 교체)
    private let previewProgress: Double = 0.72
    private let previewDayOfYear: Int = 345
    private let previewTotalDays: Int = 365
    private let previewTheme: ThemeAssets = .catBasic


    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // 1) 위젯 프리뷰
                previewCard

                // 2) 섹션(표시 설정) - 다음 커밋에서 채울 예정
                settingsPlaceholderSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var previewCard: some View {
        VStack(spacing: 10) {
            Text("Preview")
                .font(.custom("ComicRelief-Bold", size: 16))
                .foregroundStyle(.secondary)

            // 실제 위젯 UI 재사용
            YearJourneyMediumWidgetView(
                progress: previewProgress,
                dayOfYear: previewDayOfYear,
                totalDaysInYear: previewTotalDays,
                theme: previewTheme,
                config: draftConfig,
                isTintMode: false
            )
            .padding(.vertical, 16)
            .frame(height: 170)
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }

    private var settingsPlaceholderSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Settings")
                .font(.custom("ComicRelief-Bold", size: 16))
                .foregroundStyle(.secondary)

            Text("Next: Display Mode / Colors / Reset")
                .font(.custom("ComicRelief-Regular", size: 14))
                .foregroundStyle(.secondary)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

#Preview {
    NavigationStack {
        MediumWidgetSettingsView()
    }
}
