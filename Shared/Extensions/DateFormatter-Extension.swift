//
//  DateFormatter-Extension.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import Foundation

extension DateFormatter {
    
    static let weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: Calendar.current)
    
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = Calendar.current
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
}
