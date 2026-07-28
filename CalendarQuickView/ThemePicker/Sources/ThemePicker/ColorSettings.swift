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
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                Text("Reset")
                    .font(.title3)
                Button {
                    colorStore.resetToDefaults()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .frame(width: viewModel.buttonSize, height: viewModel.buttonSize)
                        .foregroundColor(colorStore.accentColor)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            
            Text("Theme")
                .font(.title3)
            
            Divider()
            
            ForEach(UITheme.all) { theme in
                ThemeRow(
                    theme: theme,
                    isSelected: colorStore.selectedTheme.id == theme.id
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
