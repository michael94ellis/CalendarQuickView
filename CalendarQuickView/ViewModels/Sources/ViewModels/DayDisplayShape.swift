//
//  DayDisplayShape.swift
//  ViewModels
//
//  Created by Michael Ellis on 7/28/26.
//

import SwiftUI

public enum DayDisplayShape: String, CaseIterable, Sendable {
    case roundedSquare
    case square
    case circle
    case none
    
    public var shape: AnyShape {
        switch self {
        case .roundedSquare:
            return AnyShape(RoundedRectangle(cornerRadius: 4))
        case .circle:
            return AnyShape(Circle())
        case .square:
            return AnyShape(Rectangle())
        case .none:
            return AnyShape(Rectangle())
        }
    }
    
    public var displayName: String {
        switch self {
        case .square: return "Square"
        case .roundedSquare: return "Rounded Square"
        case .circle: return "Circle"
        case .none: return "None"
        }
    }
}
