//
//  StorageManager.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//

import SwiftUI

final class CalendarViewModel: ObservableObject {
    
    // MARK: - Colors
    
    @AppStorage("titleText") public var _titleTextColor: String = "contrast"
    @AppStorage("eventTextColor") public var _eventTextColor: String = "contrast"
    var eventTextColor: Color { Color("\(self._eventTextColor)") }
    @AppStorage("buttonColor") public var _buttonColor: String = "contrast"
    var buttonColor: Color { Color("\(self._buttonColor)") }
    var titleTextColor: Color { Color("\(self._titleTextColor)") }
    @AppStorage("currentMonthText") public var _currentMonthText: String = "contrast"
    var currentMonthText: Color { Color("\(self._currentMonthText)") }
    @AppStorage("currentMonthColor") public var _currentMonthColor: String = "stone"
    var currentMonthColor: Color { Color("\(self._currentMonthColor)") }
    @AppStorage("otherMonthText") public var _otherMonthText: String = "contrast"
    var otherMonthText: Color { Color("\(self._otherMonthText)") }
    @AppStorage("otherMonthColor") public var _otherMonthColor: String = "stone"
    var otherMonthColor: Color { Color("\(self._otherMonthColor)") }
    
    // MARK: - Date Formats
    
    /// Stored property to determine date format for the Title of the calendar view
    @AppStorage(AppStorageKeys.titleDateFormat) var titleDateFormat: TitleDateFormat = .shortMonthAndYear
    /// Stored property to determine date format for displayed events
    @AppStorage(AppStorageKeys.eventDateFormat) var eventDateFormat: EventDateFormat = .shortDayAndMonth
    var titleDateFormatter: DateFormatter { DateFormatter(dateFormat: self.titleDateFormat.rawValue, calendar: .current) }
    var eventDateFormatter: DateFormatter { DateFormatter(dateFormat: self.eventDateFormat.rawValue, calendar: .current) }
    
    // MARK: - Sizing
    
    /// This is the storage variable for calendar size, do not use
    @AppStorage(AppStorageKeys.calendarSize) private var storedCalendarSize: CalendarSize = .small
    /// This is for getting and setting the calendar size, will update buttonSize
    var calendarSize: CalendarSize {
        get {
            return self.storedCalendarSize
        }
        set {
            self.storedCalendarSize = newValue
        }
    }
    
    var buttonSize: CGFloat {
         self.calendarSize == .small ? 20 : self.calendarSize == .medium ? 30 : 40
    }
    
    
    // MARK: - Calendar Data
    /// Stored property to determine if the S M T W T F S row should be shown
    @AppStorage(AppStorageKeys.showWeekDayHeader) var showWeekDayHeader: Bool = true
    
    @AppStorage(AppStorageKeys.selectedDay) var selectedDate: Date = Date()
    @Published public var displayDate: Date
    public var calendar: Calendar
    @AppStorage(AppStorageKeys.dayDisplayShape) var dayDisplayShape: DayDisplayShape = .roundedSquare
    
    /// Stored property to determine if Dock Icon should be displayed
    @AppStorage(AppStorageKeys.showDockIcon) var showDockIcon: Bool = false
    
    init() {
        self.displayDate = Date()
        self.calendar = .current
    }
    
    public func resetDate() {
        self.displayDate = Date()
    }
    
    var getDayCellSize: CGFloat {
        switch(self.calendarSize) {
        case .small:
            return 25
        case .medium:
            return 30
        case .large:
            return 42
        }
    }
    
    
    /// Typealias for `(text: Color, background: Color)`
    typealias CalendarDayCellColors = (text: Color, bgColor: Color)
    func getDayColors(for date: Date, in displayMonth: Date) -> CalendarDayCellColors {
        if self.calendar.isDateInToday(date) {
            // Current Day
            return (self.currentMonthText, self.currentMonthColor)
        } else if self.calendar.isDate(date, equalTo: displayMonth, toGranularity: .month) {
            // Day in Current Displayed Month
            return (self.currentMonthText, self.currentMonthColor)
        } else {
            // Day is not in Current Displayed Month
            return (self.otherMonthText, self.otherMonthColor)
        }
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
