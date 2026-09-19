//
//  AgendaListView.swift
//  CalendarQuickView
//

import SwiftUI
import EventKit
import ViewModels

/// A simple upcoming-events list, grouped by day, as an alternative to the month grid.
struct AgendaListView: View {

    @EnvironmentObject var viewModel: CalendarViewModel
    @EnvironmentObject private var eventManager: EventKitManager

    private static let agendaWindowDays = 14
    private static let dayHeaderFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter
    }()

    private var groupedEvents: [(day: Date, events: [EKEvent])] {
        let calendar = Calendar.current
        guard let windowEnd = calendar.date(byAdding: .day, value: Self.agendaWindowDays, to: calendar.startOfDay(for: Date())) else {
            return []
        }
        let upcoming = eventManager.futureEvents.filter { $0.startDate < windowEnd }
        let grouped = Dictionary(grouping: upcoming) { calendar.startOfDay(for: $0.startDate) }
        return grouped.keys.sorted().map { day in
            (day, grouped[day, default: []].sorted { $0.startDate < $1.startDate })
        }
    }

    var body: some View {
        let fontSize: Font = viewModel.calendarSize == .small ? .callout : viewModel.calendarSize == .medium ? .body : .title3
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if groupedEvents.isEmpty {
                    Text("No upcoming events in the next \(Self.agendaWindowDays) days.")
                        .font(fontSize)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(groupedEvents, id: \.day) { group in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Self.dayHeaderFormatter.string(from: group.day))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            ForEach(Array(group.events.enumerated()), id: \.offset) { _, event in
                                HStack(spacing: 6) {
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(event.calendarColor)
                                        .frame(width: 3, height: 16)
                                    Text(event.title ?? "Untitled")
                                        .font(fontSize)
                                        .foregroundColor(event.calendarColor)
                                        .lineLimit(1)
                                    Spacer(minLength: 4)
                                    Text(viewModel.eventDateFormatter.string(from: event.startDate))
                                        .font(fontSize)
                                        .foregroundColor(event.calendarColor)
                                        .opacity(0.85)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
        .onAppear {
            eventManager.fetchEvents()
        }
    }
}
