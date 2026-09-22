//
//  CalendarSettings.swift
//  CalendarQuickView
//

import EventKit
import SwiftUI
import ViewModels

struct CalendarSettings: View {

    @EnvironmentObject private var eventManager: EventKitManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Calendars")
                .font(.title3)
                .foregroundColor(.secondary)
            Text("Choose which calendars appear in the popup and widget.")
                .foregroundColor(.secondary)

            if eventManager.eventCalendars.isEmpty {
                Text("No calendars found. Check Calendar Access in the Events tab.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                Text("Event Calendars")
                    .foregroundColor(.secondary)
                ScrollView {
                    VStack {
                        ForEach(eventManager.eventCalendars, id: \.calendarIdentifier) { calendar in
                            CalendCalendarRowView(calendar: calendar,
                                                  visibilityBinding: visibilityBinding(for:))
                            Divider()
                        }
                    }
                    
                    Text("Reminder Calendars")
                        .foregroundColor(.secondary)
                    VStack {
                        ForEach(eventManager.reminderCalendars, id: \.calendarIdentifier) { calendar in
                            CalendCalendarRowView(calendar: calendar,
                                                  visibilityBinding: visibilityBinding(for:))
                            Divider()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            eventManager.fetchEvents()
        }
    }

    private func visibilityBinding(for calendar: EKCalendar) -> Binding<Bool> {
        Binding(
            get: { eventManager.isCalendarVisible(calendar) },
            set: { eventManager.setCalendar(calendar, visible: $0) }
        )
    }
}
