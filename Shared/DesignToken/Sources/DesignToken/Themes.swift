//
//  Themes.swift
//  DesignToken
//
//  Created by Michael Ellis on 7/27/26.
//

// MARK: - Theme Presets

public enum Theme: CaseIterable {
    /// Warm coral accent on stone day cells (matches prior defaults).
    case coral
    case sky
    case forest
    case dusk
    case amber
    
    var uiTheme: UITheme {
        switch self {
        case .coral:
            UITheme(
                id: "coral",
                name: "Coral",
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
                accent: "#7C5CBF",
                todayText: "#F8F8F8",
                currentMonthText: "#1B1425",
                currentMonthBackground: "#E7DFEC",
                otherMonthText: "#3B3445",
                otherMonthBackground: "#D3CCD8"
            )
        case .amber:UITheme(
            id: "amber",
            name: "Amber",
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
