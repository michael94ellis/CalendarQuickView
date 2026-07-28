//
//  NSColor+Hex.swift
//  DesignToken
//
//  Created by Michael Ellis on 7/28/26.
//

import AppKit

extension NSColor {
    var hexString: String {
        guard let rgbColor = usingColorSpace(.sRGB) ?? usingColorSpace(.deviceRGB) else {
            return "#808080"
        }
        
        let r = Int(round(rgbColor.redComponent * 255))
        let g = Int(round(rgbColor.greenComponent * 255))
        let b = Int(round(rgbColor.blueComponent * 255))
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
