//
//  TimedThemeEvent.swift
//  YearJourney
//

import Foundation

/// 출시 후 일정 기간이 지나면 자동으로 테마를 전환하는 이벤트 정의
struct TimedThemeEvent {

    /// AppGroupStore 키 네임스페이스로 쓰이는 고유 식별자
    let id: String

    /// 이 날짜 이전에 처음 감지된 사용자는 "기존 유저"로 간주
    let cutoffDate: Date

    /// 기존 유저: 첫 감지일로부터 전환까지 대기일
    let existingUserDelay: Int

    /// 신규 유저: 첫 감지일로부터 전환까지 대기일
    let newUserDelay: Int

    /// 전환할 테마
    let themeID: ThemeID
}

extension TimedThemeEvent {

    /// 2026-06-25 박스 이벤트 — Underwater Journey 테마 출시 알림용
    static let boxCat2026 = TimedThemeEvent(
        id: "boxCat2026",
        cutoffDate: DateComponents(calendar: .current, year: 2026, month: 6, day: 25).date!,
        existingUserDelay: 3,
        newUserDelay: 10,
        themeID: .boxCat
    )

    /// 활성화된 모든 이벤트 — 새 이벤트 추가 시 이 목록에만 등록하면 됨
    static let all: [TimedThemeEvent] = [boxCat2026]
}
