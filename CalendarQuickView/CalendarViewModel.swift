//
//  StorageManager.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//

import SwiftUI

final class CalendarViewModel: ObservableObject {
    
    // MARK: - Colors
    
    @AppStorage(AppStorageKeys.currentMonthDaysBGColor) var currentMonthDaysBGColor: Color = Color.blue
    @AppStorage(AppStorageKeys.prevMonthDaysBGColor) var prevMonthDaysBGColor: Color = Color.darkGray
    @AppStorage(AppStorageKeys.nextMonthDaysBGColor) var nextMonthDaysBGColor: Color = Color.darkGray
    @AppStorage(AppStorageKeys.weekDayHeaderBGColor) var weekDayHeaderBGColor: Color = Color.darkGray
    @AppStorage(AppStorageKeys.currentDayBGColor) var currentDayBGColor: Color = Color.green
    @AppStorage(AppStorageKeys.selectedDayBGColor) var selectedDayBGColor: Color = Color.yellow
    
    @AppStorage(AppStorageKeys.currentMonthDaysTextColor) var currentMonthDaysTextColor: Color = Color.white
    @AppStorage(AppStorageKeys.prevMonthDaysTextColor) var prevMonthDaysTextColor: Color = Color.white
    @AppStorage(AppStorageKeys.nextMonthDaysTextColor) var nextMonthDaysTextColor: Color = Color.white
    @AppStorage(AppStorageKeys.weekDayHeaderTextColor) var weekDayHeaderTextColor: Color = Color.white
    @AppStorage(AppStorageKeys.currentDayTextColor) var currentDayTextColor: Color = Color.black
    @AppStorage(AppStorageKeys.selectedDayTextColor) var selectedDayTextColor: Color = Color.darkGray
    
    
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
    
    @AppStorage(AppStorageKeys.titleDateFormat) var titleDateFormat: TitleDateFormat = .shortMonthAndYear
    @AppStorage(AppStorageKeys.eventDateFormat) var eventDateFormat: EventDateFormat = .shortDayAndMonth
    @AppStorage(AppStorageKeys.showWeekDayHeader) var showWeekDayHeader: Bool = true
    
    @AppStorage(AppStorageKeys.selectedDay) var selectedDate: Date = Date()
    @Published var displayDate: Date = Date()
    public var calendar: Calendar = .current
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
    
    static public private(set) var shared = CalendarViewModel()
    private init() {
        self.displayDate = Date()
    }
    
    public func reset() {
        Self.shared = CalendarViewModel()
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
