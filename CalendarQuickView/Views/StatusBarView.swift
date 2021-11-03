//
//  StatusBarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit

struct StatusBarView: View {
    
    var body: some View {
        CalendarView()
        Button(action: { self.openSettingsWindow() }, label: { Text("Open Settings") })
            .padding(.bottom, 10)
    }
    
    func openSettingsWindow() {
        var windowRef:NSWindow
        windowRef = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 100, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        windowRef.setFrameAutosaveName("Calendar Quick View Settings")
        windowRef.isReleasedWhenClosed = false
        windowRef.contentView = NSHostingView(rootView: SettingsView())
        windowRef.makeKey()
        windowRef.orderFrontRegardless()
    }
}
