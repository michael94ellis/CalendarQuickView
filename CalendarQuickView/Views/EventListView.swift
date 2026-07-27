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
    @ObservedObject var eventManager = EventKitManager.shared
    
    var body: some View {
        let fontSize: Font = self.viewModel.calendarSize == .small ? .callout : self.viewModel.calendarSize == .medium ? .body : .title3
        if eventManager.isEventFeatureEnabled,
           eventManager.isAbleToAccessUserCalendar {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(eventManager.futureEvents.prefix(Int(eventManager.numOfEventsToDisplay)), id: \.eventIdentifier) { event in
                    HStack {
                        Text(event.title)
                            .font(fontSize)
                        Spacer()
                        Text(viewModel.eventDateFormatter.string(from: event.startDate))
                            .font(fontSize)
                    }
                    .foregroundColor(ColorStore.shared.eventTextColor)
                    .frame(height: 29)
                    Divider()
                }
            }
            .onAppear {
                eventManager.fetchEvents()
            }
        }
    }
}
