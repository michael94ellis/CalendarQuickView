//
//  Themes.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/7/21.
//

import SwiftUI

extension Color {
    static var text: Color = Color(NSColor.labelColor)
    static var button: Color = Color(NSColor.labelColor)
    static var primaryBackground: Color = Color(NSColor.systemBlue)
    static var secondaryBackground: Color = Color(NSColor.systemIndigo).opacity(0.4)
}

/// Rose App Color Them
enum RoseTheme: String, CaseIterable {
    case rose
    case lavendar
    case coral
    case tart
    case vermillion
    case pink
    case wood
    
    var displayName: String {
        switch(self) {
        case .rose: return "Rose"
        case .lavendar: return "Lavendar"
        case .coral: return "Coral"
        case .tart: return "Tart"
        case .vermillion: return "Vermillion"
        case .pink: return "Pink"
        case .wood: return "Wood"
        }
    }
}
