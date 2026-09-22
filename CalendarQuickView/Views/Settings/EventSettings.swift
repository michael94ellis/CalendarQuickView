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
        VStack(alignment: .leading, spacing: 12) {
            Text("Events and Reminders Setting")
                .font(.title3)
                .foregroundColor(.secondary)
            Text("Choose which calendars appear in the popup and widget.")
                .foregroundColor(.secondary)
            
            settingsRow("Calendar Access") {
                Button {
                    eventManager.checkCalendarAuthStatus { _ in }
                } label: {
                    HStack(spacing: 8) {
                        Text(eventManager.isAbleToAccessUserCalendar ? "Granted" : "Not Granted")
                            .foregroundColor(.secondary)
                        Image(systemName: eventManager.isAbleToAccessUserCalendar
                              ? "checkmark.circle.fill"
                              : "xmark.circle.fill")
                        .foregroundColor(eventManager.isAbleToAccessUserCalendar ? .green : .secondary)
                    }
                    .help("Recheck calendar access")
                }
                .buttonStyle(.plain)
            }
            Divider()
            
            settingsRow("Display Event Info") {
                Toggle("", isOn: $eventManager.isEventFeatureEnabled)
                    .labelsHidden()
            }
            Divider()
            
            settingsRow("Reminder Access") {
                Button {
                    eventManager.requestReminderAccess()
                } label: {
                    HStack(spacing: 8) {
                        Text(eventManager.hasReminderReadAccess ? "Granted" : "Not Granted")
                            .foregroundColor(.secondary)
                        Image(systemName: eventManager.hasReminderReadAccess
                              ? "checkmark.circle.fill"
                              : "xmark.circle.fill")
                        .foregroundColor(eventManager.hasReminderReadAccess ? .green : .secondary)
                    }
                    .help("Request or recheck Reminders access")
                }
                .buttonStyle(.plain)
            }
            Divider()
            
            settingsRow("Show Reminders") {
                Toggle("", isOn: $eventManager.isRemindersFeatureEnabled)
                    .labelsHidden()
                    .onChange(of: eventManager.isRemindersFeatureEnabled) { enabled in
                        if enabled {
                            eventManager.requestReminderAccess()
                        }
                    }
            }
            Divider()
            
            settingsRow("Event List Date Format") {
                Picker("", selection: $viewModel.eventDateFormat) {
                    ForEach(EventDateFormat.allCases, id: \.self) { dateFormatOption in
                        Text(dateFormatOption.displayName)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 230)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
    }
    
    private func settingsRow<Control: View>(
        _ title: String,
        @ViewBuilder control: () -> Control
    ) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(title)
            Spacer(minLength: 8)
            control()
        }
        .frame(minHeight: 28)
    }
}
