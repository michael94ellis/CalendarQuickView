//
//  String-Constants.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/4/21.
//

import AppKit
import SwiftUI

struct AppStorageKeys {
    static let weekDayHeaderBGColor = "weekDayHeaderBG"
    static let currentMonthDaysBGColor = "currentMonthDaysBG"
    static let prevMonthDaysBGColor = "prevMonthDaysBG"
    static let nextMonthDaysBGColor = "nextMonthDaysBG"
    static let currentDayBGColor = "currentDayBG"
    static let selectedDayBGColor = "selectedDayBG"
    
    static let weekDayHeaderTextColor = "weekDayHeaderText"
    static let currentMonthDaysTextColor = "currentMonthDaysText"
    static let prevMonthDaysTextColor = "prevMonthDaysText"
    static let nextMonthDaysTextColor = "nextMonthDaysText"
    static let currentDayTextColor = "currentDayText"
    static let selectedDayTextColor = "selectedDayText"
    
    static let titleDateFormat = "titleDateFormat"
    static let eventDateFormat = "eventDateFormat"
    static let showWeekDayHeader = "showWeekDayHeader"
    
    static let selectedDay = "selectedDay"
    static let calendarSize = "calendarSize"
    static let calendarAccessGranted = "calendarAccessGranted"
    
    static let eventDisplayFromDate = "eventDisplayFromDate"
    static let numOfEventsToDisplay = "numOfEventsToDisplay"
    static let dayDisplayShape = "dayShapeDisplay"
    static let isEventFeatureEnabled = "isEventFeatureEnabled"
}

enum CalendarSize: String, CaseIterable, Codable {
    case small
    case medium
    case large
}

enum TitleDateFormat: String, CaseIterable {
    case shortMonthOnly = "MMM"
    case shortMonthAndYear = "MMM YY"
    case fullMonthShortYear = "MMMM YY"
    case fullMonthOnly = "MMMM"
    case fullMonthAndYear = "MMMM YYYY"
    
    var displayName: String {
        switch(self) {
        case .shortMonthOnly: return "Short Month Only"
        case .shortMonthAndYear: return "Short Month and Year"
        case .fullMonthShortYear: return "Full Month Short Year"
        case .fullMonthOnly: return "Full Month Only"
        case .fullMonthAndYear: return "Full Month and Year"
        }
    }
}

/// This date format will be used in the Event List View, to display upcoming events
enum EventDateFormat: String, CaseIterable {
    /// d
    case shortDayOnly = "d"
    /// dd
    case fullDayOnly = "dd"
    /// M/d
    case shortMonthAndDay = "M/d"
    /// M/dd
    case shortMonthFullDay = "M/dd"
    /// MM/dd
    case fullMonthAndDay = "MM/dd"
    /// d/M
    case shortDayAndMonth = "d/M"
    /// dd/MM
    case fullDayFullMonth = "dd/MM"
    /// The value to display in a Picker
    var displayName: String {
        switch(self) {
        case .shortDayOnly: return "Short Day Only (7)"
        case .fullDayOnly: return "Full Day Only (07)"
        case .shortMonthAndDay: return "Short Month and Day (3/7)"
        case .shortMonthFullDay: return "Short Month Full Day (3/07)"
        case .fullMonthAndDay: return "Full Month and Day (03/07)"
        case .shortDayAndMonth: return "Short Day and Month (7/3)"
        case .fullDayFullMonth: return "Full Day and Month (07/03)"
        }
    }
}

/// The type that determines from when events are displayed on the Event List View of upcoming events
///  All events are displayed on the calendar view for the days, this is for the list of events outside of the calendar
enum EventDisplayDate: String, CaseIterable {
    case currentDay
    case currentTime
    
    var displayName: String {
        switch(self) {
        case .currentDay: return "Today"
        case .currentTime: return "Current Time"
        }
    }
}

enum DayDisplayShape: String, CaseIterable {
    case square
    case roundedSquare
    case circle
    
    var displayName: String {
        switch(self) {
        case .square: return "Square"
        case .roundedSquare: return "Rounded Square"
        case .circle: return "Circle"
        }
    }
}

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}
