//
//  EventSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct EventSettings: View {
    
    @ObservedObject var eventManager = EventKitManager.shared
    @ObservedObject var viewModel = CalendarViewModel.shared
    
    func TextWithFrame(_ text: String) -> some View {
        Text(text).frame(height: 25)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.eventManager.requestAccessToCalendar { success in
                    print("Event access - \(success)")
                }
            },
                   label: {
                HStack {
                    Text("Calendar Access")
                    Image(systemName:  eventManager.isAbleToAccessUserCalendar ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(eventManager.isAbleToAccessUserCalendar ? .green : .white)
                }
            })
            Button(action: {
                self.eventManager.isEventFeatureEnabled.toggle()
            },
                   label: {
                HStack {
                    Text("Display Event Info")
                    Image(systemName: eventManager.isEventFeatureEnabled ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(eventManager.isEventFeatureEnabled ? .green : .white)
                }
            })
            HStack {
                VStack(alignment: .leading) {
                    TextWithFrame("Show Events Starting From: ")
                    TextWithFrame("Event List Date Format")
                    TextWithFrame("Events to display: \(Int(eventManager.numOfEventsToDisplay))")
                }
                VStack(alignment: .trailing) {
                    HStack {
                        Picker("", selection: eventManager.$eventDisplayFromDate) {
                            ForEach(EventDisplayDate.allCases, id: \.self) { eventDisplayDate in
                                Text(eventDisplayDate.displayName)
                            }
                        }
                    }
                    .frame(height: 25)
                    Picker("", selection: $viewModel.eventDateFormat) {
                        ForEach(EventDateFormat.allCases, id: \.self) { dateFormatOption in
                            Text(dateFormatOption.displayName)
                        }
                    }
                    .frame(height: 25)
                    Slider(value: $eventManager.numOfEventsToDisplay, in: 1...10, step: 1.0)
                        .frame(height: 25)
                }
                .frame(width: 280)
            }
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
