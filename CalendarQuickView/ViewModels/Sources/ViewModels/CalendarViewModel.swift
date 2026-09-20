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

    /// Shows the week-of-year number in a gutter in front of each week row.
    @AppStorage(AppStorageKeys.showWeekNumbers) public var showWeekNumbers: Bool = false

    /// Width of the week-number gutter, sized to fit two digits at the current calendar size.
    public var weekNumberColumnWidth: CGFloat { getDayCellSize * 0.8 }

    /// Week of the year for the week containing `date`, following the user's locale for when a
    /// year's first week begins.
    public func weekOfYear(for date: Date) -> Int {
        calendar.component(.weekOfYear, from: date)
    }
    @AppStorage(AppStorageKeys.viewMode) public var viewMode: CalendarViewMode = .month

    /// Natural height of the month layout, remembered so the Agenda view can match it even when
    /// the popup opens straight into Agenda mode and the month layout never renders.
    @AppStorage(AppStorageKeys.measuredMonthContentHeight) public var measuredMonthContentHeight: Double = 0

    /// Empty means "no secondary time zone selected."
    @AppStorage(AppStorageKeys.secondaryTimeZoneIdentifier) public var secondaryTimeZoneIdentifier: String = ""

    public var secondaryTimeZone: TimeZone? {
        secondaryTimeZoneIdentifier.isEmpty ? nil : TimeZone(identifier: secondaryTimeZoneIdentifier)
    }

    /// Current time in the selected secondary time zone, e.g. "3:45 PM PST", or nil if none is set.
    public var secondaryTimeZoneTimeString: String? {
        guard let timeZone = secondaryTimeZone else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a zzz"
        formatter.timeZone = timeZone
        return formatter.string(from: Date())
    }
    
    private var _selectedDate: Date = Date()
    public var selectedDate: Date {
        get { _selectedDate }
        set {
            objectWillChange.send()
            _selectedDate = calendar.startOfDay(for: newValue)
        }
    }
    
    @Published public var displayDate: Date
    public var calendar: Calendar
    @AppStorage(AppStorageKeys.dayDisplayShape) public var dayDisplayShape: DayDisplayShape = .roundedSquare
    @AppStorage(AppStorageKeys.showDockIcon) public var showDockIcon: Bool = false
    
    public init() {
        displayDate = Date.now
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
        let weekNumberGutter = showWeekNumbers ? weekNumberColumnWidth + weekDaySpacing : 0
        return (getDayCellSize * 7) + (weekDaySpacing * 6) + (horizontalPadding * 2) + weekNumberGutter
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
