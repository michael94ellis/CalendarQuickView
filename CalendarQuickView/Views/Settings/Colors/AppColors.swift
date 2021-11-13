//
//  AppColors.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/7/21.
//

import SwiftUI

/// Rose App Color Them
enum AppColors: String, CaseIterable {
    case contrast
    case coral
    case jet
    case jonquil
    case lavendar
    case mustard
    case onyx
    case pink
    case rose
    case sky
    case stone
    case tart
    case vermillion
    case wood
    
    var color: Color { Color(self.rawValue) }
}
