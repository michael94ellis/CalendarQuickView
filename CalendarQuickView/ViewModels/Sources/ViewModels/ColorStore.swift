//
//  ColorStore.swift
//  ViewModels
//

import DesignToken
import SwiftUI

public final class ColorStore: ObservableObject {
    
    public init() {
        print("New Color Store")
    }
    
    @AppStorage("selectedUITheme") private(set) public var selectedThemeID: String = "" {
        didSet { objectWillChange.send() }
    }
    
    public var selectedTheme: UITheme {
        UITheme.theme(id: selectedThemeID)
    }
    
    public var accentColor: Color { Color(hex: selectedTheme.accent) }
    public var surfaceColor: Color { Color(hex: selectedTheme.surface) }
    public var todayText: Color { Color(hex: selectedTheme.todayText) }
    public var currentMonthText: Color { Color(hex: selectedTheme.currentMonthText) }
    public var currentMonthColor: Color { Color(hex: selectedTheme.currentMonthBackground) }
    public var otherMonthText: Color { Color(hex: selectedTheme.otherMonthText) }
    public var otherMonthColor: Color { Color(hex: selectedTheme.otherMonthBackground) }
    
    public func selectTheme(_ theme: UITheme) {
        selectedThemeID = theme.id
    }
    
    public func resetToDefaults() {
        selectedThemeID = UITheme.default.id
    }
}
