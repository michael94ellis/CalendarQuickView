//
//  Date-Extention.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import Foundation

extension Date: RawRepresentable {
    
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
    
    public func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? self
    }
    
    public func addMonths(_ n: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: n, to: self)!
    }
    
    public mutating func incrementMonths(by n: Int, using calendar: Calendar = .current) {
        self = calendar.date(byAdding: .month, value: n, to: self) ?? self
    }
    
}
