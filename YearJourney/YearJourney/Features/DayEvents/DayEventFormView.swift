//
//  DayEventFormView.swift
//  YearJourney
//

import SwiftUI

struct DayEventFormView: View {
    @EnvironmentObject private var dayEventManager: DayEventManager
    @Environment(\.dismiss) private var dismiss

    var editing: DayEvent? = nil

    @State private var emoji: String
    @State private var title: String
    @State private var selectedDate: Date
    @State private var isRecurring: Bool
    @State private var daysBeforeToShow: Int?

    @FocusState private var emojiFieldFocused: Bool
    @FocusState private var titleFieldFocused: Bool

    private let dayOptions: [Int?] = [nil, 3, 7, 14, 30, 60]

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
            _isRecurring = State(initialValue: event.isRecurring)
            _daysBeforeToShow = State(initialValue: event.daysBeforeToShow)
        } else {
            _emoji = State(initialValue: "🎉")
            _title = State(initialValue: "")
            _selectedDate = State(initialValue: Date())
            _isRecurring = State(initialValue: true)
            _daysBeforeToShow = State(initialValue: nil)
        }
    }

    // MARK: - Computed

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !emoji.isEmpty
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                emojiTitleSection
                calendarSection
                optionsSection
                if editing != nil { deleteSection }
            }
            .listStyle(.insetGrouped)
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
        }
    }

    // MARK: - Sections

    private var emojiTitleSection: some View {
        Section {
            // Large emoji display — tap to focus emoji field
            HStack {
                Spacer()
                Button {
                    titleFieldFocused = false
                    emojiFieldFocused = true
                } label: {
                    Text(emoji.isEmpty ? "🎉" : emoji)
                        .font(.system(size: 64))
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.vertical, 8)

            // Invisible emoji field (focused when emoji area tapped)
            TextField("", text: $emoji)
                .focused($emojiFieldFocused)
                .frame(height: 0)
                .opacity(0)
                .onChange(of: emoji) { _, new in
                    if new.count > 1 { emoji = String(new.prefix(1)) }
                }

            TextField("Title", text: $title)
                .font(.custom("ComicRelief-Bold", size: 16))
                .multilineTextAlignment(.center)
                .focused($titleFieldFocused)
        }
    }

    private var calendarSection: some View {
        Section {
            DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
        }
    }

    private var optionsSection: some View {
        Section {
            Toggle(isOn: $isRecurring) {
                Text("매년 반복")
                    .font(.custom("ComicRelief-Bold", size: 16))
            }

            if isRecurring {
                Text("선택한 연도는 저장되지 않아요.")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            Picker("표시 시작", selection: $daysBeforeToShow) {
                Text("항상 표시").tag(nil as Int?)
                ForEach([3, 7, 14, 30, 60], id: \.self) { days in
                    Text("\(days)일 전").tag(days as Int?)
                }
            }
            .font(.custom("ComicRelief-Bold", size: 16))
        }
    }

    private var deleteSection: some View {
        Section {
            Button(role: .destructive) {
                if let event = editing {
                    dayEventManager.delete(id: event.id)
                    dismiss()
                }
            } label: {
                Text("이벤트 삭제")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    // MARK: - Methods

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
