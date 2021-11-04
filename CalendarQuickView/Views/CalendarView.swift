//
//  CalendarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarView: View {
    
    @State var displayDate: Date = Date()
    
    private var calendar: Calendar
    private let monthFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    
    // Constants
    private let daysInWeek = 7
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "dd", calendar: calendar)
    }
    
    private var displayMonth: DateInterval {
        calendar.dateInterval(of: .month, for: displayDate)!
    }
    
    var body: some View {
        let month = displayDate.startOfMonth(using: calendar)
        let days = makeDays()
        return VStack {
            CalendarTitle(date: displayDate, calendar: calendar)
            LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                // M T W T F S S
                // Weekday Headers
                ForEach(days.prefix(daysInWeek), id: \.self) { date in
                    Text(weekDayFormatter.string(from: date))
                }
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        Text(String(self.calendar.component(.day, from: date)))
                            .frame(width: 20, height: 20)
                            .padding(1)
                            .background(calendar.isDateInToday(date) ? Color.green : Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                            .padding(.vertical, 4)
                    } else {
                        Text(String(self.calendar.component(.day, from: date)))
                            .frame(width: 20, height: 20)
                            .padding(1)
                            .background(Color(NSColor.lightGray).opacity(0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                            .padding(.vertical, 4)
                    }
                }
            }
            .padding(.horizontal, 10)
            Spacer()
        }
    }
    
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
    
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            CalendarView(calendar: Calendar(identifier: .gregorian))
//            CalendarView(calendar: Calendar(identifier: .islamicUmmAlQura))
//            CalendarView(calendar: Calendar(identifier: .hebrew))
//            CalendarView(calendar: Calendar(identifier: .indian))
//        }
//    }
//}
