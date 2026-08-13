//
//  DayEvent.swift
//  YearJourney
//

import Foundation

struct DayEvent: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var title: String
    var emoji: String
    var month: Int       // 1–12
    var day: Int         // 1–31
    var year: Int?       // nil when isRecurring is true
    var daysBeforeToShow: Int?   // nil = 항상 표시
    var isRecurring: Bool
}

/// D-Day 이벤트용 이모지 카탈로그.
/// 각 이모지는 틴트(accented) 위젯 모드에서 사용할 SF Symbol과 1:1로 매칭된다.
/// 틴트 모드에선 이모지가 단색 실루엣으로 뭉개지므로, 매칭된 심볼로 대체 렌더한다.
enum DayEventEmoji {
    /// (이모지, 틴트 모드용 SF Symbol) — 배열 순서가 곧 피커 그리드 배치 순서.
    /// `all`과 심볼 매핑을 같은 소스에서 파생시켜 키 불일치(변형 셀렉터 등)를 방지한다.
    static let catalog: [(emoji: String, symbol: String)] = [
        // 축하 / 기념
        ("🎂", "birthday.cake.fill"),
        ("🎁", "gift.fill"),
        ("🎉", "party.popper.fill"),
        ("🎈", "balloon.fill"),
        ("🎓", "graduationcap.fill"),
        ("🏆", "trophy.fill"),
        // 여행 / 이동
        ("✈️", "airplane"),
        ("🏖️", "beach.umbrella.fill"),
        ("⛺", "tent.fill"),
        ("🗺️", "map.fill"),
        ("🚗", "car.fill"),
        ("🎬", "film.fill"),
        // 일 / 공부
        ("📚", "books.vertical.fill"),
        ("📝", "square.and.pencil"),
        ("💼", "briefcase.fill"),
        ("🎯", "target"),
        ("📅", "calendar"),
        ("⏰", "alarm.fill"),
        // 건강 / 반려 / 운동
        ("💊", "pills.fill"),
        ("🩺", "stethoscope"),
        ("🐶", "dog.fill"),
        ("🐱", "cat.fill"),
        ("🏃", "figure.run"),
        ("🏋️", "dumbbell.fill"),
        // 자연 / 여가
        ("⭐", "star.fill"),
        ("🌙", "moon.fill"),
        ("🌈", "rainbow"),
        ("⚽", "soccerball"),
        ("🎮", "gamecontroller.fill"),
        ("🏠", "house.fill"),
        // 사랑 / 만남
        ("❤️", "heart.fill"),
        ("💌", "envelope.fill"),
        ("☕", "cup.and.saucer.fill"),
        ("🍷", "wineglass.fill"),
        ("🎵", "music.note"),
        ("🎤", "music.mic")
    ]

    /// 이모지 피커에 노출되는 목록.
    static let all: [String] = catalog.map(\.emoji)

    private static let symbolByEmoji: [String: String] =
        Dictionary(uniqueKeysWithValues: catalog.map { ($0.emoji, $0.symbol) })

    /// 틴트 모드에서 사용할 SF Symbol 이름.
    /// 매핑에 없는 (구버전에서 저장된) 이모지는 폴백 심볼로 대체한다.
    static func symbolName(for emoji: String) -> String {
        symbolByEmoji[emoji] ?? "calendar"
    }
}
