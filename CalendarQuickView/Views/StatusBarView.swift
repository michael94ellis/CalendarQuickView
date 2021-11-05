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
    
    static var windowRef: NSWindow?
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarTitle(date: $displayDate, calendar: calendar)
            CalendarView(displayDate: $displayDate, calendar: self.calendar)
            Spacer()
            // Button to open Settings Window on bottom right
            HStack(spacing: 0) {
                Button(action: { Self.openSettingsWindow() }, label: { Image(systemName: "plus") })
                Spacer()
                Button(action: { Self.openSettingsWindow() }, label: { Image(systemName: "gear") })
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    static func openSettingsWindow() {
        if windowRef == nil {
            let newWindowRef = NSWindow(
                contentRect: NSRect(x: 100, y: 100, width: 100, height: 300),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            self.windowRef = newWindowRef
            self.windowRef?.setFrameAutosaveName("Calendar Quick View Settings")
            self.windowRef?.isReleasedWhenClosed = false
            self.windowRef?.contentView = NSHostingView(rootView: SettingsView(windowRef: newWindowRef))
            self.windowRef?.orderFrontRegardless()
            self.windowRef?.makeKey()
            self.windowRef?.becomeFirstResponder()
        } else {
            windowRef = nil
        }
    }
}
