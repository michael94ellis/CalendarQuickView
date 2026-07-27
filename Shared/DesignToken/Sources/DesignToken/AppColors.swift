//
//  AppColors.swift
//  DesignToken
//

import SwiftUI

/// Named theme colors backed by `Colors.xcassets` in this package.
public enum AppColors: String, CaseIterable, Sendable {
    case contrast
    case coral
    case jet
    case jonquil
    case lavendar
    case mustard
    case onyx
    case rose
    case sky
    case stone
    case tart
    case vermillion
    case wood

    public var color: Color {
        Color(rawValue, bundle: .module)
    }

    /// Resolves a persisted color name from this package's asset catalog.
    public static func color(named name: String) -> Color {
        Color(name, bundle: .module)
    }
}
