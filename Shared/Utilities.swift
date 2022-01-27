//
//  String-Constants.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/4/21.
//

import AppKit
import SwiftUI

struct AppStorageKeys {    
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
    static let showDockIcon = "showDockIcon"
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
    
    case fullDayFullMonthFullYear = "dd MMMM YYYY HH:MM"
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
        case .fullDayFullMonthFullYear: return "Full Day and Month and Year (07/03/22)"
        }
    }
}

enum DayDisplayShape: String, CaseIterable {
    case square
    case roundedSquare
    case circle
    case none
    
    var shape: AnyShape {
        switch(self) {
        case .roundedSquare:
            return AnyShape(RoundedRectangle(cornerRadius: 4))
        case .circle:
            return AnyShape(Circle())
        case .square:
            return AnyShape(Rectangle())
        case .none:
            return AnyShape(Rectangle())
        }
    }
    
    var displayName: String {
        switch(self) {
        case .square: return "Square"
        case .roundedSquare: return "Rounded Square"
        case .circle: return "Circle"
        case .none: return "None"
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
