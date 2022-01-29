//
//  EventListView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/7/21.
//

import SwiftUI
import EventKit

struct EventListView: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    @ObservedObject var eventViewModel = EventViewModel.shared
    
    init() {
        self.eventViewModel.fetchEvents(on: Date()) { _ in }
    }
    
    var body: some View {
        // Events List
        let fontSize: Font = self.viewModel.calendarSize == .small ? .callout : self.viewModel.calendarSize == .medium ? .body : .title3
        if self.eventViewModel.isEventFeatureEnabled,
           self.eventViewModel.isAbleToAccessUserCalendar {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.eventViewModel.events.prefix(Int(self.eventViewModel.numOfEventsToDisplay)), id: \.self) { event in
                    HStack {
                        Text(event.title)
                            .font(fontSize)
                        Spacer()
                        Text(viewModel.eventDateFormatter.string(from: event.startDate))
                            .font(fontSize)
                    }
                    .foregroundColor((ColorStore.shared.eventTextColor))
                    .frame(height: 29)
                    Divider()
                }
            }
        }
    }
}
