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
    
    init() {
        var compareDate = Date()
        if eventManager.eventDisplayFromDate == .currentDay,
           let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: compareDate){
            compareDate = midnight
        }
        let futureEvents = eventManager.events.filter { $0.startDate > compareDate }
        self.eventsToDisplay.append(contentsOf: futureEvents)
    }
    
    var eventsToDisplay: [EKEvent] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(self.eventsToDisplay.prefix(Int(eventManager.numOfEventsToDisplay)), id: \.self) { event in
                HStack {
                    Text(event.title)
                        .font(.body)
                    Spacer()
                    Text(viewModel.eventDateFormatter.string(from: event.startDate))
                        .font(.callout)
                }
                .foregroundColor((viewModel.eventTextColor))
                .frame(height: 29)
                Divider()
            }
        }
    }
}
