//
//  CalendarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import WidgetKit

struct CalendarView: View {
    
    @AppStorage(AppStorageKeys.currentMonthDaysColor) private var currentMonthDaysColor: Color = Color.blue
    @AppStorage(AppStorageKeys.prevMonthDaysColor) private var prevMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.nextMonthDaysColor) private var nextMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.currentDayColor) private var currentDayColor: Color = Color.green
    @AppStorage(AppStorageKeys.selectedDayColor) private var selectedDayColor: Color = Color.yellow

    @Binding var displayDate: Date
    @AppStorage(AppStorageKeys.selectedDay) var selectedDate: Date = Date()
    
    public var calendar: Calendar
    private let monthFormatter = DateFormatter.monthFormatter
    private let weekDayFormatter = DateFormatter.weekDayFormatter
    private let dayFormatter = DateFormatter.dayFormatter
    
    // Constants
    private let daysInWeek = 7
    
    
    // TODO: Make feature where user can change Calendar.Identifier
    
    private var displayMonth: DateInterval {
        calendar.dateInterval(of: .month, for: displayDate)!
    }
    /// This will do the required info gathering to create a Day view
    private func createDayNumberView(_ date: Date) -> some View {
        let month = displayDate.startOfMonth(using: calendar)
        let backgroundColor: Color
        if calendar.isDate(date, inSameDayAs: selectedDate) {
            // Selected Day
            backgroundColor = selectedDayColor
        } else if calendar.isDateInToday(date) {
            // Current Day
            backgroundColor = currentDayColor
        } else if calendar.isDate(date, equalTo: month, toGranularity: .month) {
            // Day in Current Displayed Month
            backgroundColor = currentMonthDaysColor
        } else if date < displayDate {
            // Day is before Current Displayed Month
            backgroundColor = prevMonthDaysColor
        } else {
            // Day is after Current Displayed Month
            backgroundColor = nextMonthDaysColor
        }
        return Text(String(self.calendar.component(.day, from: date)))
            .frame(width: 20, height: 20)
            .padding(1)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4.0))
            .padding(.vertical, 4)
    }
    
    var body: some View {
        // TODO: Make week able to start on any day of week(customizable)
        let days: [[Date]] = makeDays().chunked(into: 7)
        let weekDaysForHeader = days.first ?? []
        return VStack(spacing: 0) {
            // M T W T F S S
            // Weekday Headers
            HStack {
                ForEach(weekDaysForHeader.prefix(daysInWeek), id: \.self) { date in
                    Text(weekDayFormatter.string(from: date))
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 1)
                }
            }
            .padding(.vertical, 8)
            // The days of the month
            ForEach(days, id: \.self) { weekDays in
                HStack {
                    ForEach(weekDays, id:\.self) { date in
                        // Each individual day
                        createDayNumberView(date)
                        // Logic to select date
                            .onTapGesture {
                                self.selectedDate = date
                            }
                    }
                }
            }
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
