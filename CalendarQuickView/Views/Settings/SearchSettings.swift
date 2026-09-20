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
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date()
    @State private var calendarFilter: String?
    /// Everything in the chosen range. Refreshed only when the range moves, so typing filters
    /// this in memory instead of re-querying EventKit on every keystroke.
    @State private var rangeEvents: [EKEvent] = []

    private static let resultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private var visibleCalendars: [EKCalendar] {
        eventManager.eventCalendars.filter { eventManager.isCalendarVisible($0) }
    }

    private var results: [EKEvent] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return rangeEvents.filter { event in
            let matchesText = trimmed.isEmpty || (event.title ?? "").localizedCaseInsensitiveContains(trimmed)
            let matchesCalendar = calendarFilter == nil || event.calendar.calendarIdentifier == calendarFilter
            return matchesText && matchesCalendar
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Search events by title", text: $query)
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 16) {
                DatePicker("From", selection: $startDate, displayedComponents: .date)
                DatePicker("To", selection: $endDate, in: startDate..., displayedComponents: .date)
            }

            HStack(spacing: 8) {
                Text("Calendar")
                Picker("", selection: $calendarFilter) {
                    Text("All Calendars").tag(String?.none)
                    ForEach(visibleCalendars, id: \.calendarIdentifier) { calendar in
                        Text(calendar.title).tag(String?.some(calendar.calendarIdentifier))
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 200)

                Spacer()

                Text("\(results.count) event\(results.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            if !eventManager.hasCalendarReadAccess {
                Text("Calendar access isn't granted. Check Calendar Access in the Events tab.")
                    .foregroundColor(.secondary)
            } else if results.isEmpty {
                Text("No events in this range.")
                    .foregroundColor(.secondary)
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
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            // Populates the calendar list backing the scope picker.
            eventManager.fetchEvents()
            reloadRange()
        }
        .onChange(of: startDate) { _ in reloadRange() }
        .onChange(of: endDate) { _ in reloadRange() }
    }

    private func reloadRange() {
        let calendar = Calendar.current
        let from = calendar.startOfDay(for: startDate)
        // End of the chosen day, so the last day in the range is included.
        let to = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)) ?? endDate
        rangeEvents = eventManager.events(from: from, to: to)
    }
}
