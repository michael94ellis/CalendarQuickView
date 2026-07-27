//
//  EKCalendar-Extension.swift
//  CalendarQuickView
//

import AppKit
import EventKit
import SwiftUI

extension EKCalendar {
    /// The calendar's color as a SwiftUI `Color`.
    var color: Color {
        if let nsColor = NSColor(cgColor: cgColor) {
            return Color(nsColor)
        }
        return ColorStore.shared.accentColor
    }
}

extension EKEvent {
    /// Color of the calendar this event belongs to.
    var calendarColor: Color {
        calendar.color
    }
}
