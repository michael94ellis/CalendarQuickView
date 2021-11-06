//
//  StatusBarCalendar.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit

struct StatusBarCalendar: View {
    
    @AppStorage(AppStorageKeys.calendarSize) var calendarSize: CalendarSize = .small
    @State var displayDate: Date = Date()
    public var calendar: Calendar
    let titleDateFormatter: DateFormatter = DateFormatter(dateFormat: "MMM YY", calendar: .current)
    
    static var windowRef: NSWindow?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CalendarHeader(displayDate: $displayDate, calendar: self.calendar, titleFormatter: self.titleDateFormatter)
                .padding(.bottom, 4)
                .padding(.top, 8)
            CalendarBody(displayDate: $displayDate, calendar: self.calendar)
            Spacer()
            CalendarFooter(openSettings: Self.openSettingsWindow)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    /// Opens a window displaying a Swiftui View for app settings
    static func openSettingsWindow() {
        if windowRef == nil {
            let newWindowRef = NSWindow(
                contentRect: NSRect(x: 100, y: 100, width: 100, height: 400),
                styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            self.windowRef = newWindowRef
            self.windowRef?.title = "RRR"
            self.windowRef?.setFrameAutosaveName("Calendar Quick View Settings")
            self.windowRef?.isReleasedWhenClosed = false
            self.windowRef?.contentView = NSHostingView(rootView: SettingsTabView())
            self.windowRef?.orderFrontRegardless()
            self.windowRef?.makeKey()
            self.windowRef?.becomeFirstResponder()
        } else {
            windowRef = nil
        }
    }
}