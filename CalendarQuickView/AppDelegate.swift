//
//  AppDelegate.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import Cocoa
import SwiftUI
import ViewModels

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    /// Required window that is immediately closed and hidden
    var window: NSWindow!
    /// This is the Status Bar Item that is clicked to show the Calendar Quick View
    var statusBarItem: NSStatusItem?
    /// This NSMenu will show when the NSStatusItem is clicked, an alternative to NSPopover
    let menu = NSMenu()
    /// Holds the Calendar View, belongs to the NSMenuItem
    let menuItem = NSMenuItem()
    /// Displayed as the content of the NSMenuItem
    var hostingView: NSView?
    let eventKitManager = EventKitManager()
    /// Refreshes the menu bar's date number shortly after midnight.
    var dateRefreshTimer: Timer?
    
    /// Builds a hosting view sized to its SwiftUI content (height measured, width from layout).
    var newHostingView: NSView {
        if eventKitManager.isEventFeatureEnabled {
            if eventKitManager.syncAuthorizationStatus() {
                eventKitManager.fetchEvents()
            } else {
                eventKitManager.checkCalendarAuthStatus { _ in }
            }
        }
        
        let width = CalendarViewModel().menuWidth
        let rootView = StatusBarCalendar(eventManager: eventKitManager)
            .frame(width: width)
        let hostingView = NSHostingView(rootView: rootView)
        
        if #available(macOS 13.0, *) {
            hostingView.sizingOptions = [.intrinsicContentSize]
        }
        
        // Propose a wide-open height so SwiftUI can report its natural size for the fixed width.
        hostingView.setFrameSize(NSSize(width: width, height: 10_000))
        
        hostingView.frame = NSRect(origin: .zero, size: hostingView.intrinsicContentSize)
        
        return hostingView
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        _ = eventKitManager.syncAuthorizationStatus()
        self.hostingView = newHostingView
        menuItem.view = hostingView
        menu.addItem(menuItem)
        menu.delegate = self
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarItem?.menu = menu
        self.statusBarItem?.button?.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "Quick View Calendar")
        self.statusBarItem?.button?.imagePosition = .imageLeading
        updateStatusBarTitle()
        scheduleNextDateRefresh()
        HotkeyManager.shared.registerToggleShortcut { [weak self] in
            self?.statusBarItem?.button?.performClick(nil)
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        // Rebuild so the date, events, and measured height stay current
        let view = newHostingView
        hostingView = view
        menuItem.view = view
        updateStatusBarTitle()
    }

    /// Shows today's day-of-month number next to the menu bar icon, like macOS's own Calendar app.
    private func updateStatusBarTitle() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        statusBarItem?.button?.title = formatter.string(from: Date())
    }

    /// Schedules a one-shot refresh at the next midnight, then reschedules itself so the
    /// displayed day number keeps rolling over without a timer ticking all day.
    private func scheduleNextDateRefresh() {
        dateRefreshTimer?.invalidate()
        let calendar = Calendar.current
        let now = Date()
        guard let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 5), matchingPolicy: .nextTime) else {
            return
        }
        dateRefreshTimer = Timer(fire: nextMidnight, interval: 0, repeats: false) { [weak self] _ in
            self?.updateStatusBarTitle()
            self?.scheduleNextDateRefresh()
        }
        if let dateRefreshTimer {
            RunLoop.main.add(dateRefreshTimer, forMode: .common)
        }
    }

}
