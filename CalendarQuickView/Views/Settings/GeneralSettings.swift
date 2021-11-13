//
//  GeneralSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct GeneralSettings: View {
    
    @ObservedObject var viewModel: CalendarViewModel = CalendarViewModel.shared
    @ObservedObject var launchAtLoginMonitor = LaunchAtLoginMonitor.shared
    
    @State private var isDockIconDisplayed = CalendarViewModel.shared.showDockIcon
    
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
                    // Show app icon in dock
                    TextWithFrame(viewModel.showDockIcon ? "App Icon Shown In Dock" : "App Icon Not In Dock")
                    // Launch app at login
                    TextWithFrame("\(self.launchAtLoginMonitor.isLaunchAtLoginEnabled ? "App is currently in" : "Click to add to") Login Items")
                }
                .frame(width: 200)
                VStack(alignment: .trailing) {
                    // Calendar Month/Year Title Date Format
                    Picker("", selection: $viewModel.titleDateFormat) {
                        ForEach(TitleDateFormat.allCases, id: \.self) { dateFormatOption in
                            Text(dateFormatOption.displayName)
                        }
                    }
                    .frame(height: 25)
                    // Day Shape
                    Picker("", selection: $viewModel.dayDisplayShape) {
                        ForEach(DayDisplayShape.allCases, id: \.self) { option in
                            Text(option.displayName)
                        }
                    }
                    .frame(height: 25)
                    // Calendar Size
                    Picker("", selection: $viewModel.calendarSize) {
                        ForEach(CalendarSize.allCases, id: \.self) { calendarSize in
                            Text(calendarSize.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    // SMTWTFS Calendar Header Row
                    .frame(height: 25)
                    HStack {
                        Toggle("", isOn: viewModel.$showWeekDayHeader)
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                    // Show app icon in dock
                    HStack {
                        Toggle("", isOn: $isDockIconDisplayed)
                            .onChange(of: isDockIconDisplayed) { newValue in
                                viewModel.showDockIcon = isDockIconDisplayed
                                NSApp.setActivationPolicy(isDockIconDisplayed ? .regular : .accessory)
                            }
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                    // Launch app at login
                    HStack {
                        LaunchAtLoginMonitorToggle()
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
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
