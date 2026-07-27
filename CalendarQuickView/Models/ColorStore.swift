//
//  ColorStore.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/20/21.
//

import DesignToken
import SwiftUI

class ColorStore: ObservableObject {
    
    static let shared = ColorStore()
    private init() { }
    
    /// Persisted theme id from `UITheme.all`.
    @AppStorage("selectedUITheme") public var selectedThemeID: String = "" {
        didSet { objectWillChange.send() }
    }
    
    var selectedTheme: UITheme {
        UITheme.theme(id: selectedThemeID)
    }
    
    // MARK: - Resolved colors
    
    /// Shared highlight for today, month title, weekday headers, and button tints.
    var accentColor: Color { Color(hex: selectedTheme.accent) }
    /// Text drawn on the accent (today cell).
    var todayText: Color { Color(hex: selectedTheme.todayText) }
    var currentMonthText: Color { Color(hex: selectedTheme.currentMonthText) }
    var currentMonthColor: Color { Color(hex: selectedTheme.currentMonthBackground) }
    var otherMonthText: Color { Color(hex: selectedTheme.otherMonthText) }
    var otherMonthColor: Color { Color(hex: selectedTheme.otherMonthBackground) }
    
    func selectTheme(_ theme: UITheme) {
        selectedThemeID = theme.id
    }
    
    func resetToDefaults() {
        selectedThemeID = UITheme.default.id
    }
}
