//
//  AppDelegate.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import Cocoa
import SwiftUI
import LaunchAtLogin

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    /// Required window that is immediately closed and hidden
    var window: NSWindow!
    /// This is the Status Bar Item that is clicked to show the Calendar Quick View
    var statusBarItem: NSStatusItem?
    /// This NSMenu will show when the NSStatusItem is clicked, an alternative to NSPopover
    let menu = NSMenu()
    /// Holds the Calendar View, belongs to the NSMenu
    let menuItem = NSMenuItem()
    /// Displayed as the content of the NSMenuItem
    var hostingView: NSHostingView<StatusBarCalendar>?
    @AppStorage(AppStorageKeys.calendarSize) var calendarSize: CalendarSize = .small
    /// This calculated var will provide a new CalendarView when the Calendar view is opened by user
    /// Making a new one will make sure the current date is set correctly on the calendar if the user doesn't restart their computer
    var newHostingView: NSHostingView<StatusBarCalendar> {
        let newView = NSHostingView(rootView: StatusBarCalendar(calendar: .current))
        // Set the frame or it won't be shown
        let size: CGSize
        switch(self.calendarSize) {
        case .small:
            size = CGSize(width: 250, height: 300)
        case .medium:
            size = CGSize(width: 300, height: 360)
        case .large:
            size = CGSize(width: 400, height: 500)
        }
        newView.frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        return newView
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Close main app window
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        // Set the view and status menu bar item
        self.hostingView = newHostingView
        menuItem.view = newHostingView
        menu.addItem(menuItem)
        // Allow this AppDelegate, conforming to NSMenuDelegate, to know when the Calendar Quick View button is clicked
        menu.delegate = self
        // Configure the status bar menu item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarItem?.menu = menu
        self.statusBarItem?.button?.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "Quick View Calendar")        
    
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        menuItem.view = newHostingView
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    static func terminate() {
        NSApp.terminate(self)
    }
    
}

