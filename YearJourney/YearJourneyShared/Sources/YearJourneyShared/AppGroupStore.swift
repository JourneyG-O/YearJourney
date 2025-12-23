//
//  AppGroupStore.swift
//  YearJourneyShared
//
//  Created by KoJeongseok on 12/23/25.
//

import Foundation

public enum AppGroupStore {
    public static let suiteName = "group.app.stannum.YearJourney"

    public static var defaults: UserDefaults {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            fatalError("App Group UserDefaults not found")
        }
        return defaults
    }
}
