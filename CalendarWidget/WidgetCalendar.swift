//
//  WidgetCalendar.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/20/21.
//

import SwiftUI

struct WidgetCalendar: View {
    let calendarDayCellSize: CGFloat = 20
    func dayCell(for date: Date) -> some View {
        Text(String(Calendar.current.component(.day, from: date)))
            .frame(width: calendarDayCellSize, height: calendarDayCellSize)
//            .if(viewModel.dayDisplayShape != .none) { textView in
//                textView.background(dayColors.bgColor)
//                    .clipShape(dayShape)
//            }
            .padding(.vertical, 4)
    }
    
    var body: some View {
        ForEach(getGetCalendarDays().chunked(into: 7), id: \.self) { weekDays in
            HStack(spacing: 10) {
                ForEach(weekDays, id:\.self) { date in
                    // Each individual day
                    dayCell(for: date)
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
