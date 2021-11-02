//
//  WeekView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI

struct WeekView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    
    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else {
            return []
        }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    Text(String(self.calendar.component(.day, from: date)))
                        .frame(width: 20, height: 20)
                        .padding(1)
                        .background(
                            self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) ?
                                        Color.blue : Color(NSColor.lightGray).opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 4.0))
                        .padding(.vertical, 4)
                }
            }
        }
    }
}
