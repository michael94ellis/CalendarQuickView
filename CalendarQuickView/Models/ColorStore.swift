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
    
    // MARK: - Accent (signature highlight)
    
    /// Shared highlight for today, month title, weekday headers, and button tints.
    @AppStorage("accentColor") public var _accentColor: String = AppColors.coral.rawValue
    var accentColor: Color { AppColors.color(named: _accentColor) }
    
    // MARK: - Content colors
    
    @AppStorage("currentMonthText") public var _currentMonthText: String = AppColors.contrast.rawValue
    var currentMonthText: Color { AppColors.color(named: _currentMonthText) }
    @AppStorage("currentMonthColor") public var _currentMonthColor: String = AppColors.stone.rawValue
    var currentMonthColor: Color { AppColors.color(named: _currentMonthColor) }
    @AppStorage("otherMonthText") public var _otherMonthText: String = AppColors.contrast.rawValue
    var otherMonthText: Color { AppColors.color(named: _otherMonthText) }
    @AppStorage("otherMonthColor") public var _otherMonthColor: String = AppColors.stone.rawValue
    var otherMonthColor: Color { AppColors.color(named: _otherMonthColor) }
    
    func resetToDefaults() {
        _accentColor = AppColors.coral.rawValue
        _currentMonthText = AppColors.contrast.rawValue
        _currentMonthColor = AppColors.stone.rawValue
        _otherMonthText = AppColors.contrast.rawValue
        _otherMonthColor = AppColors.stone.rawValue
    }
}
