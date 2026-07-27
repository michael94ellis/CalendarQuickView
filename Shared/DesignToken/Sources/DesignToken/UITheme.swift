//
//  UITheme.swift
//  DesignToken
//

import Foundation

/// A UI color theme defined by hex values for each calendar role.
public struct UITheme: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    /// Highlight for today, title, weekday headers, and button tints.
    public let accent: String
    /// Text drawn on top of the accent (e.g. today's day number).
    public let todayText: String
    public let currentMonthText: String
    public let currentMonthBackground: String
    public let otherMonthText: String
    public let otherMonthBackground: String
    
    public init(
        id: String,
        name: String,
        accent: String,
        todayText: String,
        currentMonthText: String,
        currentMonthBackground: String,
        otherMonthText: String,
        otherMonthBackground: String
    ) {
        self.id = id
        self.name = name
        self.accent = accent
        self.todayText = todayText
        self.currentMonthText = currentMonthText
        self.currentMonthBackground = currentMonthBackground
        self.otherMonthText = otherMonthText
        self.otherMonthBackground = otherMonthBackground
    }
    
    /// Ordered list of selectable themes. Edit hex values here to restyle the app.
    public static let all: [UITheme] = { Theme.allCases.compactMap { $0.uiTheme }}()
    
    public static let `default`: UITheme = Theme.coral.uiTheme
    
    public static func theme(id: String) -> UITheme {
        all.first { $0.id == id } ?? .default
    }
}
