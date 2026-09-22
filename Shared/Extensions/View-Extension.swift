//
//  View-Extension.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/7/21.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

/// Shared chrome for every pane in the Settings window: a title, a one line
/// explanation, and a grouped `Form` holding the pane's sections.
///
/// Every pane routes its layout through here so fonts, spacing and section
/// styling stay in one place instead of drifting apart file by file.
struct SettingsPane<Content: View>: View {

    private let title: String
    private let subtitle: String
    private let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3.weight(.semibold))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            // Matches the inset a grouped Form gives its own rows, so the header
            // lines up with the content below it.
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 8)
            Form {
                content
            }
            .formStyle(.grouped)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
