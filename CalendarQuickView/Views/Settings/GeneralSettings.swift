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

    private static let timeZoneIdentifiers: [String] = TimeZone.knownTimeZoneIdentifiers.sorted()

    /// Deep link that opens the App Store straight to the review sheet for Quick Menu Calendar.
    private static let appStoreReviewURL = URL(string: "https://apps.apple.com/app/id1594094974?action=write-review")!

    func TextWithFrame(_ text: String) -> some View {
        Text(text)
            .frame(width: 200, height: 25, alignment: .leading)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    // Calendar Month/Year Title Date Format
                    TextWithFrame("Title Date Format")
                    // Day Shape
                    TextWithFrame("Day Display Shape")
                    // Calendar Size
                    TextWithFrame("Calendar Size")
                    // SMTWTFS Calendar Header Row
                    TextWithFrame("Show Weekday Header Row")
                    // Week of year number in front of each week
                    TextWithFrame("Show Week Numbers")
                    // Show app icon in dock
                    TextWithFrame(viewModel.showDockIcon ? "App Icon Shown In Dock" : "App Icon Not In Dock")
                    // Launch app at login
                    TextWithFrame("\(LaunchAtLogin.isEnabled ? "App is currently in" : "Click to add to") Login Items")
                    // Global keyboard shortcut
                    TextWithFrame("Global Shortcut")
                    // Rate the app on the App Store
                    TextWithFrame("Enjoying Quick Calendar?")
                }
                .frame(width: 200)
                VStack(alignment: .trailing) {
                    // Calendar Month/Year Title Date Format
                    Picker("", selection: $viewModel.titleDateFormat) {
                        ForEach(TitleDateFormat.allCases, id: \.self) { dateFormatOption in
                            Text(dateFormatOption.displayName)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    // Day Shape
                    Picker("", selection: $viewModel.dayDisplayShape) {
                        ForEach(DayDisplayShape.allCases, id: \.self) { option in
                            Text(option.displayName)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    // Calendar Size
                    Picker("", selection: $viewModel.calendarSize) {
                        ForEach(CalendarSize.allCases, id: \.self) { calendarSize in
                            Text(calendarSize.rawValue)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .pickerStyle(.segmented)
                    // SMTWTFS Calendar Header Row
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    HStack {
                        Toggle("", isOn: viewModel.$showWeekDayHeader)
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    // Week of year number in front of each week
                    HStack {
                        Toggle("", isOn: viewModel.$showWeekNumbers)
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    // Show app icon in dock
                    HStack {
                        Toggle("", isOn: $viewModel.showDockIcon)
                            .onChange(of: viewModel.showDockIcon) { newValue in
                                NSApp.setActivationPolicy(newValue ? .regular : .accessory)
                            }
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    // Launch app at login
                    HStack {
                        LaunchAtLoginToggle()
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    // Global keyboard shortcut
                    HStack {
                        KeyboardShortcuts.Recorder("", name: .toggleCalendar)
                        Spacer()
                    }
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    // Rate the app on the App Store
                    HStack {
                        Button("Rate on the App Store") {
                            NSWorkspace.shared.open(Self.appStoreReviewURL)
                        }
                        Spacer()
                    }
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 200)
            }
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

struct mything: View {
    @State private var isOn = false

    var body: some View {
        Toggle("Title", isOn: $isOn)
            .onChange(of: isOn) { _isOn in
                /// use _isOn here..
            }
    }
}
