//
//  Date-Extention.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import Foundation

extension Date {
      public func addMonths(_ n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: n, to: self)!
    }
}
