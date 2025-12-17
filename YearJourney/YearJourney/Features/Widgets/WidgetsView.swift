//
//  WidgetsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/20/25.
//

import SwiftUI

struct WidgetsView: View {

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                Spacer(minLength: 16)

                NavigationLink {
                    MediumWidgetSettingsView()
                } label: {
                    WidgetPreviewCard(title: "Medium") {
                        YearJourneyMediumWidgetView(
                            progress: 0.72,
                            dayOfYear: 345,
                            totalDaysInYear: 365,
                            theme: .catBasic,
                            config: .default,
                            isTintMode: false
                        )
                        .padding(16)
                    }
                }
                .buttonStyle(.plain)

                Spacer(minLength: 16)

                NavigationLink {
                    SmallWidgetSettingsView()
                } label: {
                    WidgetPreviewCard(title: "Small") {
                        GoalFillFishView(fillProgress: 0.4, theme: .catBasic)
                            .padding(16)
                    }
                }
                .buttonStyle(.plain)

                Spacer(minLength: 16)
            }
            .padding(.horizontal, 16)
            .background(Color(.systemGroupedBackground))
        }
    }

    private var header: some View {
        HStack {
            Text("Widgets")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

/// 공통 카드 컨테이너 (탭에서 “실제 위젯처럼 보이는 카드”)
struct WidgetPreviewCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("ComicRelief-Bold", size: 16))
                .foregroundStyle(.secondary)

            content
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    WidgetsView()
}
