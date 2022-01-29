//
//  EventSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct EventSettings: View {
    
    @ObservedObject var eventViewModel = EventViewModel.shared
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
                    TextWithFrame("Event List Date Format")
                    TextWithFrame("Events to display: \(Int(self.eventViewModel.numOfEventsToDisplay))")
                }
                VStack(alignment: .trailing) {
                    HStack {
                        CalendarButton(imageName: self.eventViewModel.isAbleToAccessUserCalendar ? "checkmark.circle" : "xmark.circle", animation: .linear, color: ColorStore.shared.buttonColor, size: self.viewModel.buttonSize) {
                            Task {
                                try? await EventManager.shared.fetchEvents(for: Date())
                            }
                        }
                        .foregroundColor(self.eventViewModel.isAbleToAccessUserCalendar ? .green : .white)
                        Spacer()
                    }
                    .frame(height: 25)
                    .padding(.leading, 10)
                    HStack {
                        CalendarButton(imageName: self.eventViewModel.isEventFeatureEnabled ? "checkmark.circle" : "xmark.circle", animation: .linear, color: ColorStore.shared.buttonColor, size: viewModel.buttonSize) {
                            self.eventViewModel.isEventFeatureEnabled.toggle()
                        }
                        .foregroundColor(self.eventViewModel.isEventFeatureEnabled ? .green : .white)
                        Spacer()
                    }
                    .frame(height: 25)
                    .padding(.leading, 10)
                    Picker("", selection: $viewModel.eventDateFormat) {
                        ForEach(EventDateFormat.allCases, id: \.self) { dateFormatOption in
                            Text(dateFormatOption.displayName)
                        }
                    }
                    .frame(height: 25)
                    Slider(value: self.$eventViewModel.numOfEventsToDisplay, in: 1...10, step: 1.0)
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
