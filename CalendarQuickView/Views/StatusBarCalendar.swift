//
//  StatusBarCalendar.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit
import Combine
import ViewModels

struct StatusBarCalendar: View {
    
    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var colorStore = ColorStore()
    @ObservedObject var eventManager: EventKitManager
    static var windowRef: NSWindow?
    private var horizontalPadding: CGFloat = 10
    
    init(eventManager: EventKitManager) {
        self.eventManager = eventManager
        let size = CalendarViewModel().calendarSize
        self.horizontalPadding = size == .small ? 10 : size == .medium ? 15 : 23
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CalendarHeader()
                .padding(.bottom, 4)
            CalendarBody()
                .padding(.bottom, 4)
            EventListView()
            CalendarFooter(openSettings: Self.openSettingsWindow)
        }
        .environmentObject(viewModel)
        .environmentObject(colorStore)
        .environmentObject(eventManager)
        .id(colorStore.selectedThemeID)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 12)
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
            Self.windowToFront()
        } else {
            Self.windowToFront()
        }
    }
    
    static private func windowToFront() {
        self.windowRef?.orderFrontRegardless()
        self.windowRef?.makeKey()
        self.windowRef?.becomeFirstResponder()
    }
}
