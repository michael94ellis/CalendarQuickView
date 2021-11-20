//
//  WidgetCalendarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/20/21.
//

import SwiftUI

struct WidgetCalendarView: View {
    
    let displayMonth = Date()
    let weekDayFormatter = DateFormatter.weekDayFormatter
    var days: [[Date]] = []
    
    init() {
        let daysToDisplay = getGetCalendarDays().chunked(into: 7)
        self.days = daysToDisplay
    }
    
    var body: some View {
        GeometryReader { parent in
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 4) {
                    ForEach(self.days.first ?? [], id: \.self) { date in
                        Text(weekDayFormatter.string(from: date))
                            .font(.caption)
                            .frame(width: parent.size.height / 10, height: parent.size.height / 10)
                    }
                }
                .foregroundColor(ColorStore.shared.titleTextColor)
                ForEach(getGetCalendarDays().chunked(into: 7), id: \.self) { weekDays in
                    HStack(spacing: 4) {
                        Spacer()
                        ForEach(weekDays, id:\.self) { date in
                            // Each individual day
                            CalendarDay(date: date, fontSize: .caption, cellSize: parent.size.height / 10, dayShape: .roundedSquare, month: self.displayMonth)
                                .padding(.vertical, 2)
                        }
                        Spacer()
                    }
                }
                Spacer()
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
