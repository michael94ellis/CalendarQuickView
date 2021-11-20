//
//  ColorStore.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/20/21.
//

import SwiftUI

class ColorStore: ObservableObject {
    
    static let shared = ColorStore()
    private init() { }
    
    // MARK: - Colors
    
    @AppStorage("titleText") public var _titleTextColor: String = "contrast"
    @AppStorage("eventTextColor") public var _eventTextColor: String = "contrast"
    var eventTextColor: Color { Color("\(self._eventTextColor)") }
    @AppStorage("buttonColor") public var _buttonColor: String = "contrast"
    var buttonColor: Color { Color("\(self._buttonColor)") }
    var titleTextColor: Color { Color("\(self._titleTextColor)") }
    @AppStorage("currentMonthText") public var _currentMonthText: String = "contrast"
    var currentMonthText: Color { Color("\(self._currentMonthText)") }
    @AppStorage("currentMonthColor") public var _currentMonthColor: String = "stone"
    var currentMonthColor: Color { Color("\(self._currentMonthColor)") }
    @AppStorage("otherMonthText") public var _otherMonthText: String = "contrast"
    var otherMonthText: Color { Color("\(self._otherMonthText)") }
    @AppStorage("otherMonthColor") public var _otherMonthColor: String = "stone"
    var otherMonthColor: Color { Color("\(self._otherMonthColor)") }
}
