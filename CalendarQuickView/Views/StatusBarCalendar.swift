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

/// Reports the month layout's natural height so the Agenda view can match it.
private struct MonthContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct StatusBarCalendar: View {

    @ObservedObject private var viewModel = CalendarViewModel()
    @StateObject private var colorStore = ColorStore()
    @ObservedObject var eventManager: EventKitManager
    static var windowRef: NSWindow?
    static var quickAddWindowRef: NSWindow?
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

            // NSMenu measures an item's view once, when the menu opens, and will not re-lay it
            // out afterwards. Both modes therefore have to occupy the same height, or switching
            // between them mid-open clips the content or leaves a blank gap.
            ZStack {
                if viewModel.viewMode == .month {
                    monthContent
                        .transition(.opacity)
                } else {
                    AgendaListView()
                        .frame(height: monthContentHeight)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.viewMode)

            CalendarFooter(
                openSettings: Self.openSettingsWindow,
                openQuickAdd: {
                    Self.openQuickAddWindow(
                        defaultDate: viewModel.selectedDate,
                        eventManager: eventManager
                    )
                }
            )
        }
        .environmentObject(viewModel)
        .environmentObject(eventManager)
        .id(colorStore.selectedThemeID)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 12)
    }

    /// The month grid is left unconstrained so it is never clipped; its measured height is what
    /// the Agenda view is pinned to.
    private var monthContent: some View {
        VStack(spacing: 0) {
            CalendarBody()
                .padding(.bottom, 4)
            EventListView()
            ReminderListView()
        }
        .background(
            GeometryReader { proxy in
                Color.clear.preference(key: MonthContentHeightKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(MonthContentHeightKey.self) { height in
            guard height > 0, abs(Double(height) - viewModel.measuredMonthContentHeight) > 0.5 else { return }
            viewModel.measuredMonthContentHeight = Double(height)
        }
    }

    private var monthContentHeight: CGFloat {
        let measured = CGFloat(viewModel.measuredMonthContentHeight)
        return measured > 0 ? measured : estimatedMonthContentHeight
    }

    /// Only used until the month layout has been measured once (its height is then remembered
    /// across launches), so this needs to be close, not exact.
    private var estimatedMonthContentHeight: CGFloat {
        let cell = viewModel.getDayCellSize
        let weekDayHeader = viewModel.showWeekDayHeader ? cell + 16 : 0
        let grid = 8 + weekDayHeader + (6 * (cell + 8)) + 4
        return grid + eventSlotHeight + reminderSlotHeight
    }

    private var eventSlotHeight: CGFloat {
        eventManager.isEventFeatureEnabled && eventManager.hasCalendarReadAccess
            ? EventListView.slotHeight
            : 0
    }

    private var reminderSlotHeight: CGFloat {
        eventManager.isRemindersFeatureEnabled && eventManager.hasReminderReadAccess
            ? ReminderListView.slotHeight
            : 0
    }

    /// Opens a window displaying a Swiftui View for app settings
    static func openSettingsWindow() {
        if windowRef == nil {
            let newWindowRef = NSWindow(
                contentRect: NSRect(x: 100, y: 100, width: 640, height: 480),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered, defer: false)
            self.windowRef = newWindowRef
            self.windowRef?.title = "Settings"
            self.windowRef?.setFrameAutosaveName("Calendar Quick View Settings")
            self.windowRef?.isReleasedWhenClosed = false
            let hostingView = NSHostingView(rootView: SettingsTabView())
            self.windowRef?.contentView = hostingView
            // An autosaved frame can predate the current layout; size to the content so the
            // window never opens too short to show a tab in full.
            self.windowRef?.setContentSize(hostingView.fittingSize)
            Self.windowToFront()
        } else {
            Self.windowToFront()
        }
    }

    /// Opens the add-event form in its own window. It cannot live inside the status menu: a menu
    /// runs its own event-tracking run loop where no view becomes first responder, so a text
    /// field there never receives typing.
    static func openQuickAddWindow(defaultDate: Date, eventManager: EventKitManager) {
        (NSApp.delegate as? AppDelegate)?.menu.cancelTracking()

        let isNewWindow = quickAddWindowRef == nil
        let window = quickAddWindowRef ?? NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 220),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        quickAddWindowRef = window
        window.title = "New Event"
        window.isReleasedWhenClosed = false

        // Rebuilt on each open so the form starts empty, on whichever day is selected.
        let form = QuickAddEventView(defaultDate: defaultDate) {
            quickAddWindowRef?.close()
        }
        .environmentObject(eventManager)
        let hostingView = NSHostingView(rootView: form)
        window.contentView = hostingView
        window.setContentSize(hostingView.fittingSize)
        if isNewWindow {
            window.center()
        }

        activateApp()
        window.makeKeyAndOrderFront(nil)
    }

    static private func windowToFront() {
        // Activating first is what lets the window become key — without it the Search tab's
        // text field cannot take keystrokes, since this is an accessory (menu bar) app.
        activateApp()
        self.windowRef?.orderFrontRegardless()
        self.windowRef?.makeKey()
        self.windowRef?.becomeFirstResponder()
    }

    /// Needed because this is an accessory (menu bar) app — without activating, a newly opened
    /// window cannot become key and take keyboard input.
    static private func activateApp() {
        if #available(macOS 14.0, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
