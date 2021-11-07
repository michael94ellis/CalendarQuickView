//
//  GeneralSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct GeneralSettings: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared
    @ObservedObject var launchAtLoginMonitor = LaunchAtLoginMonitor.shared
    @State var selectedTitleDateFormat: TitleDateFormat = .shortMonthAndYear
    
    func TextWithFrame(_ text: String) -> some View {
        Text(text).frame(height: 25)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    TextWithFrame("Title Date Format")
                    TextWithFrame("Day Display Shape")
                    TextWithFrame("Calendar Size")
                    TextWithFrame("Show Weekday Header Row")
                    TextWithFrame("\(self.launchAtLoginMonitor.isLaunchAtLoginEnabled ? "App is currently in" : "Click to add to") Login Items")
                }
                VStack(alignment: .trailing) {
                    Picker("", selection: $viewModel.titleDateFormat) {
                        ForEach(TitleDateFormat.allCases, id: \.self) { dateFormatOption in
                            Text(dateFormatOption.displayName)
                        }
                    }
                    .frame(height: 25)
                    Picker("", selection: $viewModel.dayDisplayShape) {
                        ForEach(DayDisplayShape.allCases, id: \.self) { option in
                            Text(option.displayName)
                        }
                    }
                    .frame(height: 25)
                    Picker("", selection: $viewModel.calendarSize) {
                        ForEach(CalendarSize.allCases, id: \.self) { calendarSize in
                            Text(calendarSize.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(height: 25)
                    HStack {
                        Toggle("", isOn: viewModel.$showWeekDayHeader)
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                    HStack {
                        LaunchAtLoginMonitorToggle()
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(height: 25)
                }
                .frame(width: 250)
            }
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
