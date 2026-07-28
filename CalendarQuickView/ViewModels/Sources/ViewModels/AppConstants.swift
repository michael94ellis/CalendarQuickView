//
//  AppConstants.swift
//  ViewModels
//

import SwiftUI

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

public enum DayDisplayShape: String, CaseIterable, Sendable {
    case square
    case roundedSquare
    case circle
    case none
    
    public var shape: AnyShape {
        switch self {
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
    
    public var displayName: String {
        switch self {
        case .square: return "Square"
        case .roundedSquare: return "Rounded Square"
        case .circle: return "Circle"
        case .none: return "None"
        }
    }
}
