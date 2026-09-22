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

    /// Left and right halves of the theme list. Splitting on `count - half` keeps the
    /// middle theme visible if an odd number of themes is ever added.
    private var themeColumns: (leading: [UITheme], trailing: [UITheme]) {
        let allThemes = UITheme.all
        let half = allThemes.count / 2
        return (Array(allThemes.prefix(half)), Array(allThemes.suffix(allThemes.count - half)))
    }

    private func themeRow(for theme: UITheme) -> some View {
        ThemeRow(
            theme: theme,
            isSelected: colorStore.selectedTheme.id == theme.id
        ) {
            colorStore.selectTheme(theme)
        }
    }

    public var body: some View {
        SettingsPane(title: "Color Theme",
                     subtitle: "Pick the palette used by the calendar popup and widget.") {
            Section("Themes") {
                HStack(alignment: .top, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(themeColumns.leading) { theme in
                            themeRow(for: theme)
                        }
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(themeColumns.trailing) { theme in
                            themeRow(for: theme)
                        }
                    }
                }
            }
        }
    }
}
