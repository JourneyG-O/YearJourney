//
//  AppGroupStore.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/17/25.
//

import Foundation

enum AppGroupStore {
    static let suiteName = "group.app.stannum.YearJourney"
    static let defaults: UserDefaults = {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            fatalError("App Group UserDefaults not found")
        }
        return defaults
    }()
}
