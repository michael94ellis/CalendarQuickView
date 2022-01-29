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
                return (ColorStore.shared.currentMonthText, ColorStore.shared.currentMonthColor)
            } else if Calendar.current.isDate(self.date, equalTo: month, toGranularity: .month) {
                // Day in Current Displayed Month
                return (ColorStore.shared.currentMonthText, ColorStore.shared.currentMonthColor)
            } else {
                // Day is not in Current Displayed Month
                return (ColorStore.shared.otherMonthText, ColorStore.shared.otherMonthColor)
            }
        }
    }
}
