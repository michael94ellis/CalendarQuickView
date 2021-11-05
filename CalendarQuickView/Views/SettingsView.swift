//
//  SettingsView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/1/21.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    var windowRef: NSWindow
    @State var showMenuButton: Bool = true
    @ObservedObject var eventManager = EventKitManager.shared
    @ObservedObject var launchAtLoginMonitor = LaunchAtLoginMonitor.shared
    
    //    @State var currentMonthDaysColor: Color = .white {
    //        didSet {
    //            UserDefaults.standard.setColor(color: currentMonthDaysColor, forKey: AppStorageKeys.currentMonthDaysColor)
    //        }
    //    }
    @AppStorage(AppStorageKeys.currentMonthDaysColor) private var currentMonthDaysColor: Color = Color.blue
    @AppStorage(AppStorageKeys.prevMonthDaysColor) private var prevMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.nextMonthDaysColor) private var nextMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.currentDayColor) private var currentDayColor: Color = Color.green
    @AppStorage(AppStorageKeys.selectedDayColor) private var selectedDayColor: Color = Color.yellow
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Text("Calendar Quick View Settings")
                .font(.title)
                .padding()
            HStack {
                Text("\(self.launchAtLoginMonitor.isLaunchAtLoginEnabled ? "App is currently in" : "Click to add to") Login Items")
                LaunchAtLoginMonitorToggle()
            }
            Button(action: {
                self.eventManager.requestAccessToCalendar { success in
                    print("Event access - \(success)")
                    self.windowRef.orderFrontRegardless()
                    self.windowRef.makeKey()
                }
            },
                   label: {
                HStack {
                    Text("Calendar Access")
                    Image(systemName:  EventKitManager.shared.isAbleToAccessUserCalendar ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(EventKitManager.shared.isAbleToAccessUserCalendar ? .green : .white)
                }
            })
            ColorPicker("Current Day Color", selection: $currentDayColor)
            ColorPicker("Selected Day Color", selection: $selectedDayColor)
            ColorPicker("Previous Month Day Color", selection: $prevMonthDaysColor)
            ColorPicker("Current Month Day Color", selection: $currentMonthDaysColor)
            ColorPicker("Next Month Day Color", selection: $nextMonthDaysColor)
            // Quit Button
            Button(action: {
                // FIXME: takes 2 clicks to close, should only take 1 even if it has to have a delay
                AppDelegate.terminate()
            }, label: { Text("Quit") })
                .padding()
            Spacer()
        }
        .frame(width: 480)
        Spacer()
    }
}
