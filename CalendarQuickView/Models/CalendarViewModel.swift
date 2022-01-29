//
//  StorageManager.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//

import SwiftUI
import EventKit

class CalendarViewModel: ObservableObject {
    
    // MARK: - Date Formats
    
    /// Stored property to determine date format for the Title of the calendar view
    @AppStorage(AppStorageKeys.titleDateFormat) var titleDateFormat: TitleDateFormat = .shortMonthAndYear
    /// Stored property to determine date format for displayed events
    @AppStorage(AppStorageKeys.eventDateFormat) var eventDateFormat: EventDateFormat = .shortDayAndMonth
    var titleDateFormatter: DateFormatter { DateFormatter(dateFormat: self.titleDateFormat.rawValue, calendar: .current) }
    var eventDateFormatter: DateFormatter { DateFormatter(dateFormat: self.eventDateFormat.rawValue, calendar: .current) }
    
    @Published var displayDatesEvents: [EKEvent] = []
    
    static var shared = CalendarViewModel()
    private init() {
        self.displayDate = Date()
        self.calendar = .current
    }
    
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
    var calendarTitleSize: Font { self.calendarSize == .small ? .title2 : self.calendarSize == .medium ? .title : .largeTitle }
    
    
    // MARK: - Calendar Data
    /// Stored property to determine if the S M T W T F S row should be shown
    @AppStorage(AppStorageKeys.showWeekDayHeader) var showWeekDayHeader: Bool = true
    
    @AppStorage(AppStorageKeys.selectedDay) var selectedDate: Date = Date()
    @Published public var displayDate: Date
    public var calendar: Calendar
    @AppStorage(AppStorageKeys.dayDisplayShape) var dayDisplayShape: DayDisplayShape = .roundedSquare
    
    /// Stored property to determine if Dock Icon should be displayed
    @AppStorage(AppStorageKeys.showDockIcon) var showDockIcon: Bool = false
    
    public func resetDate() {
        self.displayDate = Date()
    }
    
    var getDayCellSize: CGFloat {
        switch(self.calendarSize) {
        case .small:
            return 24
        case .medium:
            return 30
        case .large:
            return 42
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
        Task {
            let events = try await EventManager.shared.fetchEvents(startDate: monthFirstWeek.start, endDate: sixWeeksFromStart)
            DispatchQueue.main.async {
                self.displayDatesEvents = events
            }
        }
        return calendar.generateDays(for: dateInterval)
    }
}
