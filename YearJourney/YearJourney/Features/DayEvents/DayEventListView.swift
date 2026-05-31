//
//  DayEventListView.swift
//  YearJourney
//

import SwiftUI

struct DayEventListView: View {
    @EnvironmentObject private var dayEventManager: DayEventManager

    @State private var showAddForm = false
    @State private var editingEvent: DayEvent? = nil

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                header

                List {
                    ForEach(dayEventManager.events) { event in
                        DayEventRow(event: event)
                            .contentShape(Rectangle())
                            .onTapGesture { editingEvent = event }
                            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { dayEventManager.delete(id: dayEventManager.events[$0].id) }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))

            addButton
        }
        .sheet(isPresented: $showAddForm) {
            DayEventFormView()
        }
        .sheet(item: $editingEvent) { event in
            DayEventFormView(editing: event)
        }
    }

    // MARK: - Sections

    private var header: some View {
        HStack {
            Text("D-Day")
                .font(.custom("ComicRelief-Bold", size: 30))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    private var addButton: some View {
        Button {
            showAddForm = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.primary)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }
}

// MARK: - Row

private struct DayEventRow: View {
    let event: DayEvent

    var body: some View {
        HStack(spacing: 12) {
            Text(event.emoji)
                .font(.system(size: 28))

            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.custom("ComicRelief-Bold", size: 16))
                    .foregroundStyle(.primary)

                Text(subtitleText)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
    }

    private var subtitleText: String {
        let dateText = event.isRecurring
            ? String(format: "%d / %d", event.month, event.day)
            : String(format: "%d / %d / %d", event.year ?? 0, event.month, event.day)
        let recurText = event.isRecurring ? "매년" : "1회"
        return "\(dateText)  ·  \(recurText)"
    }
}
