//
//  StatusBarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit

struct StatusBarView: View {
    
    @State var displayDate: Date = Date()
    public var calendar: Calendar
    
    var body: some View {
        CalendarTitle(date: $displayDate, calendar: calendar)
        CalendarView(displayDate: $displayDate, calendar: self.calendar)
        Spacer()
        // Button to open Settings Window on bottom right
        HStack(spacing: 0) {
            Spacer()
            Button(action: { self.openSettingsWindow() }, label: { Image(systemName: "gear") })
                .padding(.horizontal, 10)
        }
        .padding(.bottom, 10)
    }
    
    func openSettingsWindow() {
        var windowRef: NSWindow
        windowRef = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 100, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        windowRef.setFrameAutosaveName("Calendar Quick View Settings")
        windowRef.isReleasedWhenClosed = false
        windowRef.contentView = NSHostingView(rootView: SettingsView(windowRef: windowRef))
        windowRef.orderFrontRegardless()
        windowRef.makeKey()
    }
}
