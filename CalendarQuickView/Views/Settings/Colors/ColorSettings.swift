//
//  ColorSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import DesignToken
import SwiftUI

struct ColorSettings: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    @ObservedObject var colorStore: ColorStore = ColorStore.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                Text("Reset")
                    .font(.title3)
                CalendarButton(
                    imageName: "arrow.triangle.2.circlepath",
                    animation: .linear,
                    color: colorStore.accentColor,
                    size: viewModel.buttonSize
                ) {
                    colorStore.resetToDefaults()
                }
                Spacer()
            }
            
            Text("Theme")
                .font(.title3)
            
            Divider()
            
            ForEach(UITheme.all) { theme in
                ThemeRow(
                    theme: theme,
                    isSelected: colorStore.selectedThemeID == theme.id
                ) {
                    colorStore.selectTheme(theme)
                }
            }
            
            Spacer()
        }
        .frame(width: 250)
        .padding(.vertical, 20)
    }
}

private struct ThemeRow: View {
    let theme: UITheme
    let isSelected: Bool
    let onSelect: () -> Void
    
    private var swatchHexes: [String] {
        [
            theme.accent,
            theme.currentMonthText,
            theme.currentMonthBackground,
            theme.otherMonthBackground,
        ]
    }
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 10) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color(hex: theme.accent))
                    .frame(width: 18)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(theme.name)
                        .foregroundColor(.primary)
                    HStack(spacing: 4) {
                        ForEach(swatchHexes, id: \.self) { hex in
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
                    .fill(isSelected ? Color(hex: theme.accent).opacity(0.12) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
