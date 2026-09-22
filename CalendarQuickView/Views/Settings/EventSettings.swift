//
//  EventSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI
import ViewModels

struct EventSettings: View {

    @EnvironmentObject private var eventManager: EventKitManager
    @EnvironmentObject var viewModel: CalendarViewModel

    var body: some View {
        SettingsPane(title: "Events and Reminders",
                     subtitle: "Control access and how events and reminders are displayed.") {
            Section("Access") {
                LabeledContent("Calendar Access") {
                    accessButton(isGranted: eventManager.isAbleToAccessUserCalendar,
                                 help: "Recheck calendar access") {
                        eventManager.checkCalendarAuthStatus { _ in }
                    }
                }
                LabeledContent("Reminder Access") {
                    accessButton(isGranted: eventManager.hasReminderReadAccess,
                                 help: "Request or recheck Reminders access") {
                        eventManager.requestReminderAccess()
                    }
                }
            }

            Section("Display") {
                Toggle("Display Event Info", isOn: $eventManager.isEventFeatureEnabled)
                Toggle("Show Reminders", isOn: $eventManager.isRemindersFeatureEnabled)
                    .onChange(of: eventManager.isRemindersFeatureEnabled) { enabled in
                        if enabled {
                            eventManager.requestReminderAccess()
                        }
                    }
                Picker("Event List Date Format", selection: $viewModel.eventDateFormat) {
                    ForEach(EventDateFormat.allCases, id: \.self) { dateFormatOption in
                        Text(dateFormatOption.displayName)
                    }
                }
            }
        }
    }

    /// Granted/Not Granted status that doubles as the button to re-request access.
    private func accessButton(isGranted: Bool,
                              help: String,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(isGranted ? "Granted" : "Not Granted")
                    .foregroundColor(.secondary)
                Image(systemName: isGranted ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isGranted ? .green : .secondary)
            }
            .help(help)
        }
        .buttonStyle(.plain)
    }
}
