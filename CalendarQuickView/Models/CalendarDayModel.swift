//
//  CalendarDayModel.swift
//  CalendarQuickView
//
//  Created by Deepak on 27/01/22.
//


import Foundation
import SwiftUI
import EventKit

struct CalendarDayModel: Identifiable {
    
    let id = UUID()
    let date: Date
    let fontSize: Font
    let cellSize: CGFloat
    let dayShape: DayDisplayShape
    let month: Date
    
    var dayColors: (text: Color, bgColor: Color) {
        get {
            if Calendar.current.isDateInToday(self.date) {
                // Current Day
                return (.black, Color(white: 0.95, opacity: 1.0))
            } else if Calendar.current.isDate(self.date, equalTo: month, toGranularity: .month) {
                // Day in Current Displayed Month
                return (.black, Color(white: 0.95, opacity: 1.0))
            } else {
                // Day is not in Current Displayed Month
                return (.gray, Color(white: 0.95, opacity: 1.0))
            }
        }
    }
    
    var otherMonthColors: (Color, Color) {
        return (.gray, Color(white: 0.95, opacity: 1.0))
    }
}
