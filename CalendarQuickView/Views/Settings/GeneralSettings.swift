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
    
    var body: some View {
        VStack {
            HStack {
                Text("Title Date Format")
                Picker("", selection: $viewModel.titleDateFormatter) {
                    ForEach(TitleDateFormat.allCases, id: \.self) { titleDateFormatOption in
                        Text(titleDateFormatOption.displayName)
                    }
                }
                .frame(width: 200)
            }
            HStack {
                Text("Show Weekday Header Row")
                Toggle("", isOn: viewModel.$showWeekDayHeader)
            }
            HStack {
                Text("Calendar Size")
                Picker("", selection: $viewModel.calendarSize) {
                    ForEach(CalendarSize.allCases, id: \.self) { calendarSize in
                        Text(calendarSize.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
            }
            HStack(alignment: .bottom) {
                Text("\(self.launchAtLoginMonitor.isLaunchAtLoginEnabled ? "App is currently in" : "Click to add to") Login Items")
                LaunchAtLoginMonitorToggle()
            }
            Button(action: {
                // FIXME: takes 2 clicks to close, should only take 1 even if it has to have a delay
                NSApp.terminate(self)
            }, label: { Text("Quit App") })
                .padding()
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
