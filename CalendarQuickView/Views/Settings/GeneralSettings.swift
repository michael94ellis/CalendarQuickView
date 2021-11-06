//
//  GeneralSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

enum CalendarSize: String, CaseIterable, Codable {
    case small
    case medium
    case large
}

struct GeneralSettings: View {
    
    @AppStorage(AppStorageKeys.calendarSize) var calendarViewSize: CalendarSize = CalendarSize.small
    
    @ObservedObject var launchAtLoginMonitor = LaunchAtLoginMonitor.shared
    
    var body: some View {
        VStack {
            HStack {
                Text("Calendar Size")
                Picker("", selection: $calendarViewSize) {
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
