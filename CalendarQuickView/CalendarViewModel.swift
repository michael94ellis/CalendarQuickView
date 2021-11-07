//
//  StorageManager.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//

import SwiftUI

final class CalendarViewModel: ObservableObject {
    
    // MARK: - Colors
    
    @AppStorage(AppStorageKeys.currentMonthDaysColor) var currentMonthDaysColor: Color = Color.blue
    @AppStorage(AppStorageKeys.prevMonthDaysColor) var prevMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.nextMonthDaysColor) var nextMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.weekDayHeaderColor) var weekDayHeaderColor: Color = Color.darkGray
    @AppStorage(AppStorageKeys.currentDayColor) var currentDayColor: Color = Color.green
    @AppStorage(AppStorageKeys.selectedDayColor) var selectedDayColor: Color = Color.yellow
    
    
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
    
    @AppStorage(AppStorageKeys.titleDateFormat) var titleDateFormatter: TitleDateFormat = .shortMonthAndYear
    @AppStorage(AppStorageKeys.showWeekDayHeader) var showWeekDayHeader: Bool = true
    
    @AppStorage(AppStorageKeys.selectedDay) var selectedDate: Date = Date()
    @Published var displayDate: Date = Date()
    public var calendar: Calendar = .current
    
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
