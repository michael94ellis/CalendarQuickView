//
//  UITheme.swift
//  DesignToken
//

import Foundation

/// A UI color theme defined by hex values for each calendar role.
public struct UITheme: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    /// Menu / calendar chrome background behind the grid.
    public let surface: String
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
        surface: String,
        accent: String,
        todayText: String,
        currentMonthText: String,
        currentMonthBackground: String,
        otherMonthText: String,
        otherMonthBackground: String
    ) {
        self.id = id
        self.name = name
        self.surface = surface
        self.accent = accent
        self.todayText = todayText
        self.currentMonthText = currentMonthText
        self.currentMonthBackground = currentMonthBackground
        self.otherMonthText = otherMonthText
        self.otherMonthBackground = otherMonthBackground
    }
    
    /// Ordered list of selectable themes.
    public static let all: [UITheme] = Theme.allCases.map(\.uiTheme)
    
    public static let `default`: UITheme = Theme.system.uiTheme
    
    public static func theme(id: String) -> UITheme {
        all.first { $0.id == id } ?? .default
    }
}
