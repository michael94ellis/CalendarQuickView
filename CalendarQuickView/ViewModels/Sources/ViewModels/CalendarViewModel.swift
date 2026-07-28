//
//  CalendarViewModel.swift
//  ViewModels
//

import SwiftUI

public final class CalendarViewModel: ObservableObject {
    
    @AppStorage(AppStorageKeys.titleDateFormat) public var titleDateFormat: TitleDateFormat = .shortMonthAndYear
    @AppStorage(AppStorageKeys.eventDateFormat) public var eventDateFormat: EventDateFormat = .shortDayAndMonth
    
    public var titleDateFormatter: DateFormatter {
        DateFormatter(dateFormat: titleDateFormat.rawValue, calendar: .current)
    }
    public var eventDateFormatter: DateFormatter {
        DateFormatter(dateFormat: eventDateFormat.rawValue, calendar: .current)
    }
    
    @AppStorage(AppStorageKeys.calendarSize) private var storedCalendarSize: CalendarSize = .small
    public var calendarSize: CalendarSize {
        get { storedCalendarSize }
        set {
            Task { @MainActor in
                storedCalendarSize = newValue
            }
        }
    }
    
    public var buttonSize: CGFloat {
        calendarSize == .small ? 20 : calendarSize == .medium ? 30 : 40
    }
    
    public var calendarTitleSize: Font {
        calendarSize == .small ? .title2 : calendarSize == .medium ? .title : .largeTitle
    }
    
    @AppStorage(AppStorageKeys.showWeekDayHeader) public var showWeekDayHeader: Bool = true
    
    @AppStorage(AppStorageKeys.selectedDay) private var storedSelectedDate: Date = Date()
    public var selectedDate: Date {
        get { storedSelectedDate }
        set {
            objectWillChange.send()
            storedSelectedDate = calendar.startOfDay(for: newValue)
        }
    }
    
    @Published public var displayDate: Date
    public var calendar: Calendar
    @AppStorage(AppStorageKeys.dayDisplayShape) public var dayDisplayShape: DayDisplayShape = .roundedSquare
    @AppStorage(AppStorageKeys.showDockIcon) public var showDockIcon: Bool = false
    
    public init() {
        displayDate = Date()
        calendar = .current
    }
    
    public func resetDate() {
        displayDate = Date()
        selectedDate = Date()
    }
    
    public func selectDate(_ date: Date) {
        selectedDate = date
        if !calendar.isDate(date, equalTo: displayDate, toGranularity: .month) {
            displayDate = date
        }
    }
    
    public var getDayCellSize: CGFloat {
        switch calendarSize {
        case .small: return 24
        case .medium: return 30
        case .large: return 42
        }
    }
    
    public var menuWidth: CGFloat {
        let horizontalPadding: CGFloat
        switch calendarSize {
        case .small: horizontalPadding = 10
        case .medium: horizontalPadding = 15
        case .large: horizontalPadding = 23
        }
        let weekDaySpacing: CGFloat = 10
        return (getDayCellSize * 7) + (weekDaySpacing * 6) + (horizontalPadding * 2)
    }
    
    public func getGetCalendarDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let sixWeeksFromStart = Calendar.current.date(byAdding: .day, value: 7 * 6, to: monthFirstWeek.start) else {
            return []
        }
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: sixWeeksFromStart)
        return calendar.generateDays(for: dateInterval)
    }
}
