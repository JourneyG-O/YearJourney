//
//  ProgressCalculator.swift
//  YearJourney
//
//  Created by KoJeongseok on 11/21/25.
//

import Foundation

struct YearProgressInfo {
    let date: Date
    let progress: Double
    let dayOfYear: Int
    let totalDaysInYeal: Int
}

enum ProgressCalculator {

    static func yearProgress(
        for date: Date = Date(),
        calendar: Calendar = .current
    ) -> YearProgressInfo {

        // 1) 기준 연도
        let year = calendar.component(.year, from: date)

        // 2) 연초 / 다음 해 연초
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) ?? date
        let startOfNextYear = calendar.date(
            from: DateComponents(year: year + 1, month: 1, day: 1)
        ) ?? date
        
        // 3) 총 일수
        let totalDaysInYear: Int
        if let days = calendar.dateComponents([.day], from: startOfYear, to: startOfNextYear).day {
            totalDaysInYear = days
        } else {
            totalDaysInYear = 365
        }

        // 4) dayOfYear (오늘이 몇 번째 날인지)
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1

        // 5) 진행률 계산 (0.0 ~ 1.0)
        let clampedDay = max(1, min(totalDaysInYear, dayOfYear))
        let progress = Double(clampedDay) / Double(totalDaysInYear)

        return YearProgressInfo(
            date: date,
            progress: progress,
            dayOfYear: clampedDay,
            totalDaysInYeal: totalDaysInYear
        )
    }
}
