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

            if eventManager.calendars.isEmpty {
                Text("No calendars found. Check Calendar Access in the Events tab.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(eventManager.calendars, id: \.calendarIdentifier) { calendar in
                            calendarRow(for: calendar)
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            eventManager.fetchEvents()
        }
    }

    private func calendarRow(for calendar: EKCalendar) -> some View {
        Toggle(isOn: visibilityBinding(for: calendar)) {
            HStack(spacing: 8) {
                Circle()
                    .fill(calendar.color)
                    .frame(width: 10, height: 10)
                Text(calendar.title)
            }
        }
        .toggleStyle(.checkbox)
        .padding(.vertical, 8)
    }

    private func visibilityBinding(for calendar: EKCalendar) -> Binding<Bool> {
        Binding(
            get: { eventManager.isCalendarVisible(calendar) },
            set: { eventManager.setCalendar(calendar, visible: $0) }
        )
    }
}
