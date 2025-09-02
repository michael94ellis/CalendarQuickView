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
    
    var dayColors: (Color, Color) {
        if Calendar.current.isDateInToday(self.date) {
            // Current Day
            return (.primary, .secondarySystemBackground)
        } else if Calendar.current.isDate(self.date, equalTo: month, toGranularity: .month) {
            // Day in Current Displayed Month
            return (.primary, .secondarySystemBackground)
        } else {
            // Day is not in Current Displayed Month
            return (.secondary, .secondarySystemBackground)
        }
    }
}


extension Color {
    static let secondarySystemBackground: Color = .init(
        NSColor.windowBackgroundColor
    )
}
