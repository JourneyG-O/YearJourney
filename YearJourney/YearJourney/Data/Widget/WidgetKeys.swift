//
//  WidgetKeys.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import Foundation

enum WidgetKeys {

    // Theme
    static let selectedThemeID = "theme.selectedThemeID"

    // Medium Widget
    static let mediumDisplayMode = "widget.medium.displayMode"
    static let mediumBackgroundColor = "widget.medium.colors.background"
    static let mediumBarColor = "widget.medium.colors.bar"
    static let mediumTextColor = "widget.medium.colors.text"
    static let mediumConfig = "widget.medium.config"

    // Small Widget
    static let smallDisplayMode = "widget.small.displayMode"
    static let smallBackgroundColor = "widget.small.colors.background"
    static let smallBarColor = "widget.small.colors.bar"
    static let smallTextColor = "widget.small.colors.text"
    static let smallConfig = "widget.small.config"

    // D-Day
    static let dayEvents = "dayEvents"
    static let isPurchased = "store.isPurchased"

    // Box Event
    static let boxEventShown = "boxEvent.shown"
    static let boxEventVersion = "boxEvent.version"
    static let boxEventOriginalThemeID = "boxEvent.originalThemeID"
    static let widgetFirstSetupDate = "widget.firstSetupDate"
}
