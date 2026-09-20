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
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose which calendars appear in the popup and widget.")
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
                .padding(.top, 20)

            if eventManager.eventCalendars.isEmpty {
                Text("No calendars found. Check Calendar Access in the Events tab.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
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
                    .padding(.horizontal, 24)
                    
                    Text("Reminder Calendars")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)
                    VStack {
                        ForEach(eventManager.reminderCalendars, id: \.calendarIdentifier) { calendar in
                            CalendCalendarRowView(calendar: calendar,
                                                  visibilityBinding: visibilityBinding(for:))
                            Divider()
                        }
                    }
                    .padding(.horizontal, 24)
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
