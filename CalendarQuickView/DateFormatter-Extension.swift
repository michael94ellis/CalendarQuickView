//
//  DateFormatter-Extension.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import Foundation

extension DateFormatter {
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}
