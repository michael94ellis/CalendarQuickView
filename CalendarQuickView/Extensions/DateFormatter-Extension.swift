//
//  DateFormatter-Extension.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import Foundation

extension DateFormatter {
    
    static var monthFormatter: DateFormatter { DateFormatter(dateFormat: "MMMM", calendar: Calendar.current) }
    static var weekDayFormatter: DateFormatter { DateFormatter(dateFormat: "EEEEE", calendar: Calendar.current) }
    static var dayFormatter: DateFormatter { DateFormatter(dateFormat: "dd", calendar: Calendar.current) }
    
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
}
