//
//  ColorSettings.swift
//  ThemePicker
//

import DesignToken
import SwiftUI
import ViewModels

public struct ColorSettings: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    private let colorStore = ColorStore()
    
    public init() {}
    
    private func themeRow(for theme: UITheme) -> some View {
        ThemeRow(
            theme: theme,
            isSelected: colorStore.selectedTheme.id == theme.id
        ) {
            colorStore.selectTheme(theme)
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Theme")
                .font(.title3)
            
            Divider()
            let allThemes = UITheme.all
            let half = allThemes.count / 2
            let firstHalf = allThemes.prefix(half)
            let secondHalf = allThemes.suffix(half)
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(firstHalf) { theme in
                        themeRow(for: theme)
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(secondHalf) { theme in
                        themeRow(for: theme)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
