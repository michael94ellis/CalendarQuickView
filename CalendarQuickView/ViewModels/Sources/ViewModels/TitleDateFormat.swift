//
//  TitleDateFormat.swift
//  ViewModels
//
//  Created by Michael Ellis on 7/28/26.
//

public enum TitleDateFormat: String, CaseIterable, Sendable {
    case shortMonthOnly = "MMM"
    case shortMonthAndYear = "MMM YY"
    case fullMonthShortYear = "MMMM YY"
    case fullMonthOnly = "MMMM"
    case fullMonthAndYear = "MMMM YYYY"
    
    public var displayName: String {
        switch self {
        case .shortMonthOnly: return "Short Month Only"
        case .shortMonthAndYear: return "Short Month and Year"
        case .fullMonthShortYear: return "Full Month Short Year"
        case .fullMonthOnly: return "Full Month Only"
        case .fullMonthAndYear: return "Full Month and Year"
        }
    }
}
