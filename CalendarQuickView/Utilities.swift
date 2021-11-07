//
//  String-Constants.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/4/21.
//

import AppKit
import SwiftUI

struct AppStorageKeys {
    static let weekDayHeaderColor = "weekDayHeaderColor"
    static let currentMonthDaysColor = "currentMonthDays"
    static let prevMonthDaysColor = "prevMonthDays"
    static let nextMonthDaysColor = "nextMonthDays"
    static let currentDayColor = "currentDayColor"
    static let selectedDayColor = "selectedDayColor"
    
    static let titleDateFormat = "titleDateFormat"
    static let showWeekDayHeader = "showWeekDayHeader"
    
    static let selectedDay = "selectedDay"
    static let calendarSize = "calendarSize"
    static let calendarAccessGranted = "calendarAccessGranted"
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
        case .shortMonthAndYear :return "Short Month and Year"
        case .fullMonthShortYear :return "Full Month Short Year"
        case .fullMonthOnly :return "Full Month Only"
        case .fullMonthAndYear :return "Full Month and Year"
        }
    }
}
