//
//  FoundationExtensions.swift
//  ViewModels
//

import Foundation

extension Date: @retroactive RawRepresentable {
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
    
    public mutating func incrementMonths(by n: Int, using calendar: Calendar = .current) {
        self = calendar.date(byAdding: .month, value: n, to: self) ?? self
    }
}

extension Calendar {
    public func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date else { return }
            guard date < dateInterval.end else {
                stop = true
                return
            }
            dates.append(date)
        }
        
        return dates
    }
    
    public func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

extension DateFormatter {
    public static let weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: .current)
    
    public convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}
