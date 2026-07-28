//
//  Themes.swift
//  DesignToken
//
//  Created by Michael Ellis on 7/27/26.
//

import AppKit

// MARK: - Theme Presets

public enum Theme: CaseIterable {
    case system
    case crispWhite
    case obsidian
    case coral
    case sky
    case forest
    case dusk
    case amber
    
    var uiTheme: UITheme {
        switch self {
        case .system:
            UITheme(
                id: "system",
                name: "System",
                surface: NSColor.windowBackgroundColor.hexString,
                accent: NSColor.controlAccentColor.hexString,
                todayText: NSColor.windowBackgroundColor.hexString,
                currentMonthText: NSColor.labelColor.hexString,
                currentMonthBackground: NSColor.controlBackgroundColor.hexString,
                otherMonthText: NSColor.secondaryLabelColor.hexString,
                otherMonthBackground: NSColor.windowBackgroundColor.hexString
            )
        case .crispWhite:
            UITheme(
                id: "crispWhite",
                name: "Crisp White",
                surface: "#FFFFFF",
                accent: "#000000",
                todayText: "#FFFFFF",
                currentMonthText: "#000000",
                currentMonthBackground: "#F4F4F5",
                otherMonthText: "#737373",
                otherMonthBackground: "#FAFAFA"
            )
        case .obsidian:
            UITheme(
                id: "obsidian",
                name: "Obsidian",
                surface: "#09090B",
                accent: "#A1A1AA",
                todayText: "#09090B",
                currentMonthText: "#FAFAFA",
                currentMonthBackground: "#27272A",
                otherMonthText: "#71717A",
                otherMonthBackground: "#18181B"
            )
        case .coral:
            UITheme(
                id: "coral",
                name: "Coral",
                surface: "#F3F2EF",
                accent: "#F67F7F",
                todayText: "#F8F8F8",
                currentMonthText: "#060606",
                currentMonthBackground: "#9F9E98",
                otherMonthText: "#060606",
                otherMonthBackground: "#B8B7B1"
            )
        case .sky:
            UITheme(
                id: "sky",
                name: "Sky",
                surface: "#F7F4F5",
                accent: "#20B0DF",
                todayText: "#F8F8F8",
                currentMonthText: "#1A110C",
                currentMonthBackground: "#F6E8EA",
                otherMonthText: "#353636",
                otherMonthBackground: "#E8E4E5"
            )
        case .forest:
            UITheme(
                id: "forest",
                name: "Forest",
                surface: "#EEF3F0",
                accent: "#2A7B58",
                todayText: "#F8F8F8",
                currentMonthText: "#131E18",
                currentMonthBackground: "#D8E3DB",
                otherMonthText: "#3E4943",
                otherMonthBackground: "#C0CAC3"
            )
        case .dusk:
            UITheme(
                id: "dusk",
                name: "Dusk",
                surface: "#F4F1F6",
                accent: "#7C5CBF",
                todayText: "#F8F8F8",
                currentMonthText: "#1B1425",
                currentMonthBackground: "#E7DFEC",
                otherMonthText: "#3B3445",
                otherMonthBackground: "#D3CCD8"
            )
        case .amber:
            UITheme(
                id: "amber",
                name: "Amber",
                surface: "#FBF7F0",
                accent: "#E08B2A",
                todayText: "#F8F8F8",
                currentMonthText: "#231B10",
                currentMonthBackground: "#FAF0E4",
                otherMonthText: "#3E372E",
                otherMonthBackground: "#EAE0D4"
            )
        }
    }
}
