//
//  DayEventFormView.swift
//  YearJourney
//

import SwiftUI

struct DayEventFormView: View {
    @EnvironmentObject private var dayEventManager: DayEventManager
    @Environment(\.dismiss) private var dismiss

    var editing: DayEvent? = nil

    // MARK: - Form state

    @State private var emoji: String
    @State private var title: String
    @State private var selectedDate: Date
    @State private var dateSelected: Bool  // true only when user explicitly picks a date
    @State private var isRecurring: Bool
    @State private var daysBeforeToShow: Int?

    // MARK: - UI state

    @State private var showEmojiPicker = false
    @FocusState private var titleFocused: Bool

    // MARK: - Init

    init(editing: DayEvent? = nil) {
        self.editing = editing
        if let event = editing {
            _emoji = State(initialValue: event.emoji)
            _title = State(initialValue: event.title)
            var c = DateComponents()
            c.year = event.year ?? Calendar.current.component(.year, from: Date())
            c.month = event.month
            c.day = event.day
            _selectedDate = State(initialValue: Calendar.current.date(from: c) ?? Date())
            _dateSelected = State(initialValue: true)
            _isRecurring = State(initialValue: event.isRecurring)
            _daysBeforeToShow = State(initialValue: event.daysBeforeToShow)
        } else {
            _emoji = State(initialValue: "🎉")
            _title = State(initialValue: "")
            _selectedDate = State(initialValue: Date())
            _dateSelected = State(initialValue: false)
            _isRecurring = State(initialValue: false)
            _daysBeforeToShow = State(initialValue: 7)
        }
    }

    // MARK: - Validation
    // 타이틀 + 날짜 직접 선택까지 완료해야 저장 가능

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && dateSelected
    }

    // Custom binding: DatePicker 값이 바뀌면 dateSelected = true
    private var dateBinding: Binding<Date> {
        Binding(
            get: { selectedDate },
            set: {
                selectedDate = $0
                dateSelected = true
            }
        )
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    calendarCard
                    optionsCard
                    if editing != nil { deleteCard }
                }
                .padding(16)
                .padding(.bottom, 8)
            }
            .background(Color(.systemGroupedBackground))
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        save()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1 : 0.4)
                }
            }
            .sheet(isPresented: $showEmojiPicker) {
                EmojiPickerView(selectedEmoji: $emoji)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - Cards

    // 미리알림 스타일 — 이모지(탭 가능) + 타이틀 입력
    private var headerCard: some View {
        VStack(spacing: 16) {
            Button {
                titleFocused = false
                showEmojiPicker = true
            } label: {
                ZStack(alignment: .topTrailing) {
                    Text(emoji)
                        .font(.system(size: 64))
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.secondary)
                        .offset(x: 6, y: 6)
                }
            }
            .buttonStyle(.plain)

            TextField("Title", text: $title)
                .font(.custom("ComicRelief-Bold", size: 17))
                .multilineTextAlignment(.center)
                .focused($titleFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.tertiarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(.vertical, 36)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var calendarCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !dateSelected {
                Text("날짜를 선택해주세요")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }

            DatePicker("", selection: dateBinding, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var optionsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Toggle(isOn: $isRecurring) {
                Text("매년 반복")
                    .font(.custom("ComicRelief-Bold", size: 16))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)

            Divider().padding(.horizontal, 14)

            HStack {
                Text("표시")
                    .font(.custom("ComicRelief-Bold", size: 16))
                Spacer()
                Picker("", selection: $daysBeforeToShow) {
                    Text("항상 표시").tag(nil as Int?)
                    ForEach([3, 7, 14, 30, 60], id: \.self) { days in
                        Text("\(days)일 전").tag(days as Int?)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var deleteCard: some View {
        Button(role: .destructive) {
            if let event = editing {
                dayEventManager.delete(id: event.id)
                dismiss()
            }
        } label: {
            Text("이벤트 삭제")
                .font(.custom("ComicRelief-Bold", size: 16))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Save

    private func save() {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let event = DayEvent(
            id: editing?.id ?? UUID(),
            title: title.trimmingCharacters(in: .whitespaces),
            emoji: emoji,
            month: c.month ?? 1,
            day: c.day ?? 1,
            year: isRecurring ? nil : c.year,
            daysBeforeToShow: daysBeforeToShow,
            isRecurring: isRecurring
        )
        if editing != nil {
            dayEventManager.update(event)
        } else {
            dayEventManager.add(event)
        }
        dismiss()
    }
}

// MARK: - Emoji Picker

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss

    private let emojis: [String] = [
        "🎂","🎁","🎉","🎊","🎈","🥳",
        "✈️","🚀","🏖️","⛺","🗺️","🎡",
        "📚","🎓","📝","✏️","💼","🖥️",
        "❤️","💕","💝","🤝","💌","🌹",
        "🏃","🏋️","⚽","🎾","🏊","🚴",
        "🌸","🌺","🌻","🌈","⭐","🌙",
        "🍕","🍰","🍜","🍣","☕","🍷",
        "🐶","🐱","🐻","🐼","🦊","🐨",
        "💊","🏥","🩺","🧸","🎮","🎵"
    ]

    private let columns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(emojis, id: \.self) { item in
                        Button {
                            selectedEmoji = item
                            dismiss()
                        } label: {
                            Text(item)
                                .font(.system(size: 36))
                                .padding(6)
                                .background(
                                    selectedEmoji == item
                                        ? Color.accentColor.opacity(0.15)
                                        : Color.clear,
                                    in: RoundedRectangle(cornerRadius: 10)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("이모지 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
        }
    }
}
