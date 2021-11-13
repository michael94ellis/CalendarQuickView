//
//  StorageManager.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//

import SwiftUI

final class CalendarViewModel: ObservableObject {
    
    /// Stored property to determine if Dock Icon should be displayed
    @AppStorage(AppStorageKeys.showDockIcon) var showDockIcon: Bool = false
    
    // MARK: - Sizing
    
    /// This is the storage variable for calendar size, do not use
    @AppStorage(AppStorageKeys.calendarSize) private var storedCalendarSize: CalendarSize = .small
    var buttonSize: CGFloat = 20
    /// This is for getting and setting the calendar size, will update buttonSize
    var calendarSize: CalendarSize {
        get {
            return self.storedCalendarSize
        }
        set {
            self.storedCalendarSize = newValue
            self.buttonSize = calendarSize == .small ? 20 : calendarSize == .medium ? 30 : 40
        }
    }
    
    // MARK: - Calendar Data
    
    /// Typealias for `(text: Color, background: Color)`
    typealias CalendarDayCellColors = (text: Color, bgColor: Color)
    func getDayColors(for date: Date, in displayMonth: Date) -> CalendarDayCellColors {
        if self.calendar.isDateInToday(date) {
            // Current Day
            return (Color.text, Color.primaryBackground)
        } else if self.calendar.isDate(date, equalTo: displayMonth, toGranularity: .month) {
            // Day in Current Displayed Month
            return (Color.text, Color.primaryBackground)
        } else {
            // Day is not in Current Displayed Month
            return (Color.text, Color.secondaryBackground)
        }
    }
    
    /// Stored property to determine date format for the Title of the calendar view
    @AppStorage(AppStorageKeys.titleDateFormat) var titleDateFormat: TitleDateFormat = .shortMonthAndYear
    
    var titleFontSize: Font {
        self.calendarSize == .small ? .title2 : self.calendarSize == .medium ? .title : .largeTitle
    }
    var weekdayHeaderSize: Font {
        self.calendarSize == .small ? .body : self.calendarSize == .medium ? .title3 : .title2
    }
    /// Stored property to determine date format for displayed events
    @AppStorage(AppStorageKeys.eventDateFormat) var eventDateFormat: EventDateFormat = .shortDayAndMonth
    /// Stored property to determine if the S M T W T F S row should be shown
    @AppStorage(AppStorageKeys.showWeekDayHeader) var showWeekDayHeader: Bool = true
    
    @AppStorage(AppStorageKeys.selectedDay) var selectedDate: Date = Date()
    @Published var displayDate: Date
    public var calendar: Calendar
    @AppStorage(AppStorageKeys.dayDisplayShape) var dayDisplayShape: DayDisplayShape = .roundedSquare
    
    // MARK: - Date Formats
    
    var titleDateFormatter: DateFormatter {
        DateFormatter(dateFormat: self.titleDateFormat.rawValue, calendar: .current)
    }
    var eventDateFormatter: DateFormatter {
        DateFormatter(dateFormat: self.eventDateFormat.rawValue, calendar: .current)
    }
    let weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: Calendar.current)
    let dayFormatter = DateFormatter(dateFormat: "dd", calendar: Calendar.current)
    
    static var shared: CalendarViewModel = CalendarViewModel()
    public init() {
        self.displayDate = Date()
        self.calendar = .current
    }
    
    public func resetDate() {
        self.displayDate = Date()
    }
    
    /// Generates 6 weeks worth of days in an array
    public func getGetCalendarDays() -> [Date] {
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
