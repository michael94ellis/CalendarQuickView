//
//  OnboardingWindow.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 9/22/26.
//

import AppKit
import SwiftUI
import ViewModels

/// Hosts `OnboardingView` in its own window. This is an accessory (menu bar) app with no windows
/// of its own at launch, so the walkthrough needs a window built by hand, the same way Settings
/// and the quick-add forms are.
enum OnboardingWindow {

    private static var windowRef: NSWindow?
    private static var closeObserver: NSObjectProtocol?

    /// Whether the walkthrough has already been shown. Written as soon as the window opens, so a
    /// user who closes it part-way is not asked again on the next launch.
    private static var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: AppStorageKeys.hasCompletedOnboarding) }
        set { UserDefaults.standard.set(newValue, forKey: AppStorageKeys.hasCompletedOnboarding) }
    }

    /// Opens the walkthrough the first time the app is ever launched, and never again.
    static func showIfNeeded(eventManager: EventKitManager) {
        guard !hasCompletedOnboarding else { return }
        show(eventManager: eventManager)
    }

    /// Opens the walkthrough unconditionally — used by the Settings button that replays it.
    static func show(eventManager: EventKitManager) {
        hasCompletedOnboarding = true

        if let window = windowRef {
            bringToFront(window)
            return
        }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 560),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        window.title = "Welcome to Calendar Quick View"
        window.isReleasedWhenClosed = false

        let hostingView = NSHostingView(rootView: OnboardingView(eventManager: eventManager) {
            close()
        })
        window.contentView = hostingView
        window.setContentSize(hostingView.fittingSize)
        window.center()

        // The window is held in `windowRef` so it stays alive while open; the reference is
        // dropped on close so a later replay builds a fresh one at step one.
        closeObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { _ in
            releaseWindow()
        }

        windowRef = window
        bringToFront(window)
    }

    static func close() {
        windowRef?.close()
    }

    private static func releaseWindow() {
        if let closeObserver {
            NotificationCenter.default.removeObserver(closeObserver)
        }
        closeObserver = nil
        windowRef = nil
    }

    /// Activating first is what lets the window become key — without it an accessory app's newly
    /// opened window cannot take keyboard input.
    private static func bringToFront(_ window: NSWindow) {
        if #available(macOS 14.0, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
        window.makeKeyAndOrderFront(nil)
    }
}
