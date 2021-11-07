//
//  StatusBarCalendar.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit

struct StatusBarCalendar: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared
    static var windowRef: NSWindow?
    var titleDateFormatter: DateFormatter = DateFormatter(dateFormat: "MMM YY", calendar: .current)
    var eventDateFormatter: DateFormatter = DateFormatter(dateFormat: "d/MM", calendar: .current)
    var horizontalPadding: CGFloat = 10
    
    init() {
        self.titleDateFormatter = DateFormatter(dateFormat: viewModel.titleDateFormatter.rawValue, calendar: .current)
        self.horizontalPadding = viewModel.calendarSize == .small ? 10 : viewModel.calendarSize == .medium ? 15 : 23
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CalendarHeader(displayDate: $viewModel.displayDate, calendar: viewModel.calendar, titleFormatter: self.titleDateFormatter)
                .padding(.bottom, 4)
                .padding(.top, 8)
            CalendarBody()
                .padding(.bottom, 4)
            VStack(alignment: .leading) {
                ForEach(EventKitManager.shared.events.prefix(4), id: \.self) { event in
                    HStack {
                        Capsule().frame(width: 4).background(Color.blue)
                        Text(event.title)
                            .font(.body)
                        Spacer()
                        Text(eventDateFormatter.string(from: event.startDate))
                            .font(.callout)
                    }
                }
            }
            Spacer()
            CalendarFooter(openSettings: Self.openSettingsWindow)
        }
        .padding(.horizontal, horizontalPadding)
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
            self.windowRef?.setFrameAutosaveName("Calendar Quick View Settings")
            self.windowRef?.isReleasedWhenClosed = false
            self.windowRef?.contentView = NSHostingView(rootView: SettingsTabView())
            self.windowRef?.orderFrontRegardless()
            self.windowRef?.makeKey()
            self.windowRef?.becomeFirstResponder()
        } else {
            self.windowRef?.orderFrontRegardless()
            self.windowRef?.makeKey()
            self.windowRef?.becomeFirstResponder()
        }
    }
}
