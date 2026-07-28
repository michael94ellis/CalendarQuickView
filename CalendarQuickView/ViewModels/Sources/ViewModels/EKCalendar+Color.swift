//
//  EKCalendar+Color.swift
//  ViewModels
//

import AppKit
import DesignToken
import EventKit
import SwiftUI

public extension EKCalendar {
    var color: Color {
        if let nsColor = NSColor(cgColor: cgColor) {
            return Color(nsColor)
        }
        return Color(hex: UITheme.default.accent)
    }
}

public extension EKEvent {
    var calendarColor: Color {
        calendar.color
    }
}
