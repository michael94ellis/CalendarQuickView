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
            .fixedSize(horizontal: true, vertical: true)
        let hostingView = NSHostingView(rootView: rootView)
        
        if #available(macOS 13.0, *) {
            hostingView.sizingOptions = [.intrinsicContentSize]
        }
        
        // Propose a wide-open height so SwiftUI can report its natural size for the fixed width.
        hostingView.setFrameSize(NSSize(width: width, height: 10_000))
        hostingView.layoutSubtreeIfNeeded()
        
        var size = hostingView.fittingSize
        if size.height < 1 {
            size.height = hostingView.intrinsicContentSize.height
        }
        size.width = width
        if size.height < 1 {
            // Last resort if the host still can't measure (should be rare).
            size.height = 400
        }
        if let visibleHeight = NSScreen.main?.visibleFrame.height {
            size.height = min(size.height, visibleHeight * 0.85)
        }
        hostingView.frame = NSRect(origin: .zero, size: size)
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
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        // Rebuild so the date, events, and measured height stay current
        let view = newHostingView
        hostingView = view
        menuItem.view = view
    }
    
}
