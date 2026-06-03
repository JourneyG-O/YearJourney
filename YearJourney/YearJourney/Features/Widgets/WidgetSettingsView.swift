//
//  WidgetSettingsView.swift
//  YearJourney
//

import SwiftUI
import WidgetKit

struct WidgetSettingsView: View {
    let kind: WidgetKind

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var originalConfig: WidgetConfig
    @State private var draftConfig: WidgetConfig

    init(kind: WidgetKind) {
        self.kind = kind
        let config = WidgetConfig.load(for: kind)
        _originalConfig = State(initialValue: config)
        _draftConfig = State(initialValue: config)
    }

    // MARK: - Computed Properties

    private var isDirty: Bool {
        draftConfig != originalConfig
    }

    private var widgetFamily: WidgetFamily {
        switch kind {
        case .small: return .systemSmall
        case .medium: return .systemMedium
        }
    }

    private var widgetKindString: String {
        switch kind {
        case .small: return "YearJourneySmallWidget"
        case .medium: return "YearJourneyMediumWidget"
        }
    }

    private var dayFractionLabel: String {
        switch kind {
        case .small: return "N/28-31"
        case .medium: return "N/365"
        }
    }

    // MARK: - Body

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
                    draftConfig.save(for: kind)
                    WidgetCenter.shared.reloadTimelines(ofKind: widgetKindString)
                    let loaded = WidgetConfig.load(for: kind)
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
    }

    // MARK: - Sections

    private var previewCard: some View {
        let widgetSize = WidgetPreviewSize.size(for: widgetFamily)

        return VStack(spacing: 10) {
            HStack {
                Text("Preview")
                    .font(.custom("ComicRelief-Bold", size: 16))
                    .foregroundStyle(.secondary)
                Spacer()
            }

            widgetPreviewView
                .frame(width: widgetSize.width, height: widgetSize.height)
                .padding(16)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .id(draftConfig.displayMode)
        }
    }

    @ViewBuilder
    private var widgetPreviewView: some View {
        switch kind {
        case .small:
            YearJourneySmallWidgetView(
                fillProgress: 0.68,
                dayOfMonth: 21,
                totalDaysInMonth: 31,
                theme: themeManager.currentTheme,
                config: draftConfig,
                isTintMode: true
            )
        case .medium:
            YearJourneyMediumWidgetView(
                progress: 0.72,
                dayOfYear: 263,
                totalDaysInYear: 365,
                theme: themeManager.currentTheme,
                config: draftConfig,
                isTintMode: false,
                isPreview: true,
                activeDayEvent: nil
            )
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
                    Text(dayFractionLabel).tag(WidgetDisplayMode.dayFraction)
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

            if kind == .medium {
                dayEventSection
            }

            Button {
                draftConfig = WidgetConfig.defaultConfig(for: kind)
            } label: {
                Text("Reset to Default")
                    .font(.custom("ComicRelief-Bold", size: 14))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isDirty)
            .opacity(isDirty ? 1 : 0.4)
        }
    }

    private var dayEventSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("D-Day")
                .font(.custom("ComicRelief-Bold", size: 14))
                .foregroundStyle(.secondary)

            Toggle(isOn: $draftConfig.showDayEvent) {
                Text("Show D-Day bubble")
                    .font(.custom("ComicRelief-Bold", size: 14))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Methods

    private func displayHintText(for mode: WidgetDisplayMode) -> String {
        switch mode {
        case .dayFraction:
            return kind == .small ? "Show day index in the month." : "Show day index in the year."
        case .percent:
            return "Show progress percentage."
        case .dRemaining:
            return "Show remaining days."
        case .off:
            return "Hide text."
        }
    }
}

#Preview {
    NavigationStack {
        WidgetSettingsView(kind: .medium)
    }
}
