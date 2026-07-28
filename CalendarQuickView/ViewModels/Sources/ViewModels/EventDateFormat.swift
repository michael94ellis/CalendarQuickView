//
//  EventDateFormat.swift
//  ViewModels
//
//  Created by Michael Ellis on 7/28/26.
//




public enum EventDateFormat: String, CaseIterable, Sendable {
    case shortDayOnly = "d"
    case fullDayOnly = "dd"
    case shortMonthAndDay = "M/d"
    case shortMonthFullDay = "M/dd"
    case fullMonthAndDay = "MM/dd"
    case shortDayAndMonth = "d/M"
    case fullDayFullMonth = "dd/MM"
    
    public var displayName: String {
        switch self {
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