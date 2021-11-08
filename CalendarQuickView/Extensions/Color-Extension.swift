//
//  Color-Extension.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/4/21.
//

import AppKit
import SwiftUI

extension Color: RawRepresentable {
    // FIXME: add opacity - https://stackoverflow.com/questions/15852122/hex-transparency-in-colors
    public init?(rawValue: Int) {
        let red =   Double((rawValue & 0xFF0000) >> 16) / 0xFF
        let green = Double((rawValue & 0x00FF00) >> 8) / 0xFF
        let blue =  Double(rawValue & 0x0000FF) / 0xFF
        self = Color(red: red, green: green, blue: blue)
    }
    public var rawValue: Int {
        let red = Int(coreImageColor.red * 255 + 0.5)
        let green = Int(coreImageColor.green * 255 + 0.5)
        let blue = Int(coreImageColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }
    private var coreImageColor: CIColor {
        CIColor(color: NSColor(self))!
    }
}

// MARK: - NSColor Conversions
public extension Color {
    static let darkGray = Color(NSColor.darkGray)
    static let lightGray = Color(NSColor.lightGray)
    static let label = Color(NSColor.labelColor)
    static let secondaryLabel = Color(NSColor.secondaryLabelColor)
    static let tertiaryLabel = Color(NSColor.tertiaryLabelColor)
    static let quaternaryLabel = Color(NSColor.quaternaryLabelColor)
    
    static let systemBackground = Color(NSColor.windowBackgroundColor)
    static let textSystemBackground = Color(NSColor.textBackgroundColor)
}

extension NSColor {
    var components: [CGFloat?] {
        let nativeColor = CIColor(color: self)
        let r = nativeColor?.red
        let g = nativeColor?.green
        let b = nativeColor?.blue
        let o = nativeColor?.alpha
        return [r, g, b, o]
    }
}
