//
//  ThemeRow.swift
//  ThemePicker
//

import DesignToken
import SwiftUI

public struct ThemeRow: View {
    let theme: UITheme
    let isSelected: Bool
    let onSelect: () -> Void
    
    public init(theme: UITheme, isSelected: Bool, onSelect: @escaping () -> Void) {
        self.theme = theme
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    private var swatchHexes: [String] {
        [
            theme.accent,
            theme.currentMonthText,
            theme.currentMonthBackground,
            theme.otherMonthBackground,
        ]
    }
    
    public var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 10) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.primary)
                    .frame(width: 18)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(theme.name)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                    HStack(spacing: 4) {
                        ForEach(Array(swatchHexes.enumerated()), id: \.offset) { _, hex in
                            Color(hex: hex)
                                .frame(width: 22, height: 14)
                                .cornerRadius(3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.primary.opacity(0.15), lineWidth: 0.5)
                                )
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(isSelected ? Color(hex: theme.accent) : Color.clear, lineWidth: 1.5)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
