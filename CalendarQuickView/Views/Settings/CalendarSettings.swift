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
        SettingsPane(title: "Selected Calendars",
                     subtitle: "Choose which calendars appear in the popup and widget.") {
            if eventManager.eventCalendars.isEmpty && eventManager.reminderCalendars.isEmpty {
                Section {
                    Text("No calendars found. Check Calendar Access in Events and Reminders.")
                        .foregroundColor(.secondary)
                }
            } else {
                if !eventManager.eventCalendars.isEmpty {
                    Section("Event Calendars") {
                        ForEach(eventManager.eventCalendars, id: \.calendarIdentifier) { calendar in
                            CalendCalendarRowView(calendar: calendar,
                                                  visibilityBinding: visibilityBinding(for:))
                        }
                    }
                }
                if !eventManager.reminderCalendars.isEmpty {
                    Section("Reminder Calendars") {
                        ForEach(eventManager.reminderCalendars, id: \.calendarIdentifier) { calendar in
                            CalendCalendarRowView(calendar: calendar,
                                                  visibilityBinding: visibilityBinding(for:))
                        }
                    }
                }
            }
        }
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
