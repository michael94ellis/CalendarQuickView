//
//  EventSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct EventSettings: View {
    
    @ObservedObject var eventManager = EventKitManager.shared
    @EnvironmentObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            settingsRow("Calendar Access") {
                HStack(spacing: 8) {
                    Text(eventManager.isAbleToAccessUserCalendar ? "Granted" : "Not Granted")
                        .foregroundColor(.secondary)
                    Button {
                        eventManager.checkCalendarAuthStatus { _ in }
                    } label: {
                        Image(systemName: eventManager.isAbleToAccessUserCalendar
                              ? "checkmark.circle.fill"
                              : "xmark.circle.fill")
                            .foregroundColor(eventManager.isAbleToAccessUserCalendar ? .green : .secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Recheck calendar access")
                }
            }
            
            settingsRow("Display Event Info") {
                Toggle("", isOn: $eventManager.isEventFeatureEnabled)
                    .labelsHidden()
                    .toggleStyle(.switch)
            }
            
            settingsRow("Event List Date Format") {
                Picker("", selection: $viewModel.eventDateFormat) {
                    ForEach(EventDateFormat.allCases, id: \.self) { dateFormatOption in
                        Text(dateFormatOption.displayName)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 230)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Events to display: \(Int(eventManager.numOfEventsToDisplay))")
                Slider(value: $eventManager.numOfEventsToDisplay, in: 1...10, step: 1)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
