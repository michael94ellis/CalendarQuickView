//
//  EventDayPopUp.swift
//  CalendarQuickView
//
//  Created by Deepak on 24/01/22.
//

import SwiftUI
import EventKit


struct EventDayPopUpView : View{
    let event: EKEvent
    var titleDateFormat: EventDateFormat = .fullDayFullMonthFullYear
    var titleDateFormatter: DateFormatter { DateFormatter(dateFormat: self.titleDateFormat.rawValue, calendar: .current) }
    var body : some View{
        ZStack{
            VStack(alignment:.leading,spacing: 5){
                Text(event.title).font(.title).padding(5).padding(.top, 10)
                Divider()
                Text(titleDateFormatter.string(from: event.startDate))
                    .font(.title3)
                    .padding(5)
                Text("No Repeat")
                    .font(.title3)
                    .padding(5)
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
