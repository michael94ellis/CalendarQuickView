//
//  HotkeyManager.swift
//  CalendarQuickView
//

import AppKit
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    /// Toggles the calendar popup. Defaults to Control+Option+C; the user can rebind it from
    /// the General settings pane.
    static let toggleCalendar = Self(
        "toggleCalendar",
        default: .init(.c, modifiers: [.control, .option])
    )
}

/// Wires the user's global shortcut to the popup toggle. `KeyboardShortcuts` registers through
/// Carbon's hot key APIs, so this needs no Accessibility permission and is safe under the App
/// Sandbox, and it re-registers on its own when the shortcut is changed in settings.
final class HotkeyManager {

    static let shared = HotkeyManager()

    private init() {}

    /// Registers the shortcut to invoke `action`. Safe to call more than once; a later call
    /// replaces the previous registration.
    func registerToggleShortcut(action: @escaping () -> Void) {
        KeyboardShortcuts.onKeyDown(for: .toggleCalendar, action: action)
    }

    /// Stops the shortcut from firing without clearing the user's chosen key combination.
    func unregister() {
        KeyboardShortcuts.disable(.toggleCalendar)
    }
}
