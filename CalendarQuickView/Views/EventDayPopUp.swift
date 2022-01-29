//
//  EventDayPopUp.swift
//  CalendarQuickView
//
//  Created by Deepak on 24/01/22.
//

import SwiftUI
import EventKit


struct EventDayPopUpView : View {
    
    let events: [EKEvent]
    var titleDateFormat: EventDateFormat = .fullDayFullMonthFullYear
    @EnvironmentObject var viewModel: CalendarViewModel
    
    var body: some View {
        List {
            ForEach(self.events) { event in
                VStack(alignment:.leading,spacing: 5) {
                    Text(event.title).font(.title).padding(5).padding(.top, 10)
                    Divider()
                    Text(self.viewModel.titleDateFormatter.string(from: event.startDate))
                        .font(.title3)
                        .padding(5)
                    if event.hasRecurrenceRules {
                        Text("No Repeat")
                            .font(.title3)
                            .padding(5)
                    }
                    Divider()
                    Text(event.notes ?? "")
                        .font(.body)
                        .padding(5)
                        .frame(width: 300, alignment: .leading)
                        .lineLimit(nil)
                    
                    Spacer()
                }
            }
        }
    }
}
