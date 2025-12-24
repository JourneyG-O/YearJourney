//
//  MediumWidgetSettingsView.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import SwiftUI
import WidgetKit

struct MediumWidgetSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var themeManager = ThemeManager.shared

    @State private var originalConfig: MediumWidgetConfig = .default
    @State private var draftConfig: MediumWidgetConfig = .default

    let family: WidgetFamily

    private var info: YearProgressInfo {
        ProgressCalculator.yearProgress()
    }

    private var isDirty: Bool {
        draftConfig != originalConfig
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                previewCard
                settingsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    draftConfig.save()
                    WidgetCenter.shared.reloadTimelines(ofKind: "YearJourneyMediumWidget")
                    let loaded = MediumWidgetConfig.load()
                    originalConfig = loaded
                    draftConfig = loaded
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                }
                .disabled(!isDirty)
                .opacity(isDirty ? 1 : 0.4)
            }
        }
        .onAppear {
            let loaded = MediumWidgetConfig.load()
            originalConfig = loaded
            draftConfig = loaded
        }
    }

    private var previewCard: some View {
        let theme = themeManager.currentTheme
        let widgetSize = WidgetPreviewSize.size(for: family)

        return VStack(spacing: 10) {
            HStack {
                Text("Preview")
                    .font(.custom("ComicRelief-Bold", size: 16))
                    .foregroundStyle(.secondary)

                Spacer()
            }


            YearJourneyMediumWidgetView(
                progress: info.progress,
                dayOfYear: info.dayOfYear,
                totalDaysInYear: info.totalDaysInYear,
                theme: theme,
                config: draftConfig,
                isTintMode: false
            )
            .frame(width: widgetSize.width, height: widgetSize.height)
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .id(draftConfig.displayMode)
        }
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.custom("ComicRelief-Bold", size: 16))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 10) {
                Text("Display")
                    .font(.custom("ComicRelief-Bold", size: 14))
                    .foregroundStyle(.secondary)

                Picker("Display Mode", selection: $draftConfig.displayMode) {
                    Text("N/365").tag(WidgetDisplayMode.dayFraction)
                    Text("%").tag(WidgetDisplayMode.percent)
                    Text("D-").tag(WidgetDisplayMode.dRemaining)
                    Text("Off").tag(WidgetDisplayMode.off)
                }
                .pickerStyle(.segmented)

                Text(displayHintText(for: draftConfig.displayMode))
                    .font(.custom("ComicRelief-Regular", size: 13))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Button {
                draftConfig = .default
            } label: {
                Text("Reset to Default")
                    .font(.custom("ComicRelief-Bold", size: 14))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isDirty)
            .opacity(isDirty ? 1: 0.4)
        }
    }

    private func displayHintText(for mode: WidgetDisplayMode) -> String {
        switch mode {
        case .dayFraction: return "Show day index in the year."
        case .percent: return "Show progress percentage."
        case .dRemaining: return "Show remaining days."
        case .off: return "Hide text."
        }
    }
}




#Preview {
    NavigationStack {
        MediumWidgetSettingsView(family: .systemMedium)
    }
}
