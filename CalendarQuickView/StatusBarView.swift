//
//  StatusBarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit
import LaunchAtLogin

struct StatusBarView: View {
    @Environment(\.calendar) var calendar
    
    @State var displayDate: Date
    
    init() {
        self._displayDate = State(wrappedValue: Date())
    }
    
    private var displayMonth: DateInterval {
        calendar.dateInterval(of: .month, for: displayDate)!
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                Button("Prev") {
                    displayDate = displayDate.addMonths(-1)
                }
                Spacer()
                Button("Next") {
                    displayDate = displayDate.addMonths(1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            CalendarView(interval: displayMonth)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .clipped()
            Spacer()
            Button("Open Settings") {
                openSettingsWindow()
            }
        }
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
