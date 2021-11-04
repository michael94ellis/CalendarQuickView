//
//  CalendarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import WidgetKit

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
        let days: [[Date]] = makeDays().chunked(into: 7)
        let weekDaysForHeader = days.first ?? []
        return VStack(spacing: 0) {
            CalendarTitle(date: $displayDate, calendar: calendar)
            // M T W T F S S
            // Weekday Headers
            HStack {
                ForEach(weekDaysForHeader.prefix(daysInWeek), id: \.self) { date in
                    Text(weekDayFormatter.string(from: date))
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 1)
                }
            }
            ForEach(days, id: \.self) { weekDays in
                HStack {
                    ForEach(weekDays, id:\.self) { date in
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
            }
            .padding(.horizontal, 10)
        }
    }
    
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let sixWeeksFromStart = Calendar.current.date(byAdding: .day, value: 7 * 6, to: monthFirstWeek.start) else {
                  return []
              }
        // get 6 weeks of days
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: sixWeeksFromStart)
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
