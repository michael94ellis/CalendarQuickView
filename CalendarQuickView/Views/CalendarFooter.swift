//
//  CalendarFooter.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI
import ViewModels

struct CalendarFooter: View {

    @EnvironmentObject var viewModel: CalendarViewModel
    @EnvironmentObject private var eventManager: EventKitManager
    private var colorStore: ColorStore = .init()

    var settingWindowCallback: () -> () = { }
    var quickAddCallback: () -> () = { }

    init(openSettings settingWindowCallback: @escaping () -> (),
         openQuickAdd quickAddCallback: @escaping () -> ()) {
        self.settingWindowCallback = settingWindowCallback
        self.quickAddCallback = quickAddCallback
    }

    var body: some View {
        HStack(spacing: 4) {
            CalendarButton(imageName: viewModel.viewMode == .month ? "list.bullet" : "calendar",
                           animation: .easeInOut,
                           color: colorStore.accentColor,
                           size: viewModel.buttonSize) {
                viewModel.viewMode = viewModel.viewMode == .month ? .agenda : .month
            }
            .foregroundColor(colorStore.accentColor)
            .help(viewModel.viewMode == .month ? "Switch to Agenda view" : "Switch to Month view")

            if eventManager.hasCalendarReadAccess {
                CalendarButton(imageName: "plus", animation: .linear, color: colorStore.accentColor, size: viewModel.buttonSize, action: self.quickAddCallback)
                    .foregroundColor(colorStore.accentColor)
                    .help("New event")
            }
            Spacer()
            CalendarButton(imageName: "gear", animation: .linear, color: colorStore.accentColor, size: viewModel.buttonSize, action: self.settingWindowCallback)
                .foregroundColor(colorStore.accentColor)
        }
    }
}
