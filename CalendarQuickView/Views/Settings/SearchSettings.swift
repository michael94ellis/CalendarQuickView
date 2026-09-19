//
//  SearchSettings.swift
//  CalendarQuickView
//

import EventKit
import SwiftUI
import ViewModels

struct SearchSettings: View {

    @EnvironmentObject private var eventManager: EventKitManager
    @State private var query: String = ""

    private static let resultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private var results: [EKEvent] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return eventManager.events
            .filter { ($0.title ?? "").localizedCaseInsensitiveContains(trimmed) }
            .sorted { $0.startDate < $1.startDate }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Search events by title", text: $query)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)
                .padding(.top, 20)

            if !eventManager.hasCalendarReadAccess {
                Text("Calendar access isn't granted. Check Calendar Access in the Events tab.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
            } else if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Searches events from one month ago to one month ahead.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
            } else if results.isEmpty {
                Text("No matching events.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(results.enumerated()), id: \.offset) { _, event in
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(event.calendarColor)
                                    .frame(width: 3, height: 16)
                                Text(event.title ?? "Untitled")
                                    .lineLimit(1)
                                Spacer(minLength: 8)
                                Text(Self.resultFormatter.string(from: event.startDate))
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            .padding(.vertical, 6)
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer()
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            eventManager.fetchEvents()
        }
    }
}
