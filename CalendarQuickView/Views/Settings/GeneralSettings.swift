//
//  GeneralSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import KeyboardShortcuts
import LaunchAtLogin
import SwiftUI
import ViewModels

struct GeneralSettings: View {

    @EnvironmentObject var viewModel: CalendarViewModel

    /// Deep link that opens the App Store straight to the review sheet for Quick Menu Calendar.
    private static let appStoreReviewURL = URL(string: "https://apps.apple.com/app/id1594094974?action=write-review")!

    var body: some View {
        SettingsPane(title: "General Settings",
                     subtitle: "Choose how the calendar looks and how you open it.") {
            Section("Calendar") {
                Picker("Title Date Format", selection: $viewModel.titleDateFormat) {
                    ForEach(TitleDateFormat.allCases, id: \.self) { dateFormatOption in
                        Text(dateFormatOption.displayName)
                    }
                }
                Picker("Day Display Shape", selection: $viewModel.dayDisplayShape) {
                    ForEach(DayDisplayShape.allCases, id: \.self) { option in
                        Text(option.displayName)
                    }
                }
                Picker("Calendar Size", selection: $viewModel.calendarSize) {
                    ForEach(CalendarSize.allCases, id: \.self) { calendarSize in
                        Text(calendarSize.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                Toggle("Show Weekday Header Row", isOn: viewModel.$showWeekDayHeader)
                Toggle("Show Week Numbers", isOn: viewModel.$showWeekNumbers)
            }

            Section("System") {
                Toggle("Show App Icon in Dock", isOn: $viewModel.showDockIcon)
                    .onChange(of: viewModel.showDockIcon) { newValue in
                        NSApp.setActivationPolicy(newValue ? .regular : .accessory)
                    }
                LabeledContent("Launch at Login") {
                    LaunchAtLoginToggle()
                }
                LabeledContent("Global Shortcut") {
                    KeyboardShortcuts.Recorder("", name: .toggleCalendar)
                }
            }

            Section("About") {
                LabeledContent("Enjoying Quick Menu Calendar?") {
                    Button("Rate on the App Store") {
                        NSWorkspace.shared.open(Self.appStoreReviewURL)
                    }
                }
            }
        }
    }
}
