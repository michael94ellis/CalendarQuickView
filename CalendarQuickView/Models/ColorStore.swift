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
    
    // MARK: - Colors
    
    @AppStorage("titleText") public var _titleTextColor: String = AppColors.contrast.rawValue
    var titleTextColor: Color { AppColors.color(named: _titleTextColor) }
    @AppStorage("eventTextColor") public var _eventTextColor: String = AppColors.contrast.rawValue
    var eventTextColor: Color { AppColors.color(named: _eventTextColor) }
    @AppStorage("buttonColor") public var _buttonColor: String = AppColors.contrast.rawValue
    var buttonColor: Color { AppColors.color(named: _buttonColor) }
    @AppStorage("currentMonthText") public var _currentMonthText: String = AppColors.contrast.rawValue
    var currentMonthText: Color { AppColors.color(named: _currentMonthText) }
    @AppStorage("currentMonthColor") public var _currentMonthColor: String = AppColors.stone.rawValue
    var currentMonthColor: Color { AppColors.color(named: _currentMonthColor) }
    @AppStorage("otherMonthText") public var _otherMonthText: String = AppColors.contrast.rawValue
    var otherMonthText: Color { AppColors.color(named: _otherMonthText) }
    @AppStorage("otherMonthColor") public var _otherMonthColor: String = AppColors.stone.rawValue
    var otherMonthColor: Color { AppColors.color(named: _otherMonthColor) }
}
