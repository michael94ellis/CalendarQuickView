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

    func TextWithFrame(_ text: String) -> some View {
        Text(text).frame(height: 25)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    TextWithFrame("Calendar Access")
                    TextWithFrame("Display Event Info")
                    TextWithFrame("Show Events Starting From: ")
                    TextWithFrame("Event List Date Format")
                    TextWithFrame("Events to display: \(Int(eventManager.numOfEventsToDisplay))")
                }
                VStack(alignment: .trailing) {
                    HStack {
                        CalendarButton(imageName: eventManager.isAbleToAccessUserCalendar ? "checkmark.circle" : "xmark.circle", buttonSize: 40, animation: .linear) {
                            self.eventManager.requestAccessToCalendar { success in
                                print("Event access - \(success)")
                            }
                        }
                        .foregroundColor(eventManager.isAbleToAccessUserCalendar ? .green : .white)
                        Spacer()
                    }
                    .frame(height: 25)
                    .padding(.leading, 10)
                    HStack {
                        CalendarButton(imageName: eventManager.isEventFeatureEnabled ? "checkmark.circle" : "xmark.circle", buttonSize: 40, animation: .linear) {
                            self.eventManager.isEventFeatureEnabled.toggle()
                        }
                        .foregroundColor(eventManager.isEventFeatureEnabled ? .green : .white)
                        Spacer()
                    }
                    .frame(height: 25)
                    .padding(.leading, 10)
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
                        .padding(.trailing, 3)
                        .padding(.leading, 10)
                }
                .frame(width: 215)
            }
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
