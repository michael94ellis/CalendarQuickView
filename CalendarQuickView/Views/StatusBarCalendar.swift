//
//  StatusBarCalendar.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit
import Combine

struct StatusBarCalendar: View {
    
    @ObservedObject var viewModel = CalendarViewModel()
    static var windowRef: NSWindow?
    var horizontalPadding: CGFloat = 10
    
    init() {
        self.horizontalPadding = self.viewModel.calendarSize == .small ? 10 : viewModel.calendarSize == .medium ? 15 : 23
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CalendarHeader()
                .padding(.bottom, 4)
                .environmentObject(viewModel)
            CalendarBody(viewModel: viewModel)
                .padding(.bottom, 4)
            EventListView()
                .environmentObject(viewModel)
            Spacer()
            CalendarFooter(openSettings: Self.openSettingsWindow)
                .environmentObject(viewModel)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 10)
    }
    
    /// Opens a window displaying a Swiftui View for app settings
    static func openSettingsWindow() {
        if windowRef == nil {
            let newWindowRef = NSWindow(
                contentRect: NSRect(x: 100, y: 100, width: 100, height: 400),
                styleMask: [.titled, .closable, .miniaturizable],
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
