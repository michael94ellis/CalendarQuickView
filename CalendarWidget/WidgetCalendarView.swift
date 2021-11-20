//
//  WidgetCalendarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/20/21.
//

import SwiftUI

struct WidgetCalendarView: View {
    
    let calendarDayCellSize: CGFloat = 15
    let displayMonth = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(getGetCalendarDays().chunked(into: 7), id: \.self) { weekDays in
                HStack(spacing: 4) {
                    ForEach(weekDays, id:\.self) { date in
                        // Each individual day
                        CalendarDay(date: date, fontSize: .caption, cellSize: self.calendarDayCellSize, dayShape: .roundedSquare, month: self.displayMonth)
                    }
                }
            }
        }
    }
    
    /// Generates 6 weeks worth of days in an array
    public func getGetCalendarDays() -> [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: Date()),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let sixWeeksFromStart = Calendar.current.date(byAdding: .day, value: 7 * 6, to: monthFirstWeek.start) else {
                  return []
              }
        // get 6 weeks of days
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: sixWeeksFromStart)
        return Calendar.current.generateDays(for: dateInterval)
    }
    
}
