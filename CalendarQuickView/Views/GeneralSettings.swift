//
//  GeneralSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct GeneralSettings: View {
    
    @ObservedObject var launchAtLoginMonitor = LaunchAtLoginMonitor.shared
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("\(self.launchAtLoginMonitor.isLaunchAtLoginEnabled ? "App is currently in" : "Click to add to") Login Items")
                LaunchAtLoginMonitorToggle()
            }
            Button(action: {
                // FIXME: takes 2 clicks to close, should only take 1 even if it has to have a delay
                AppDelegate.terminate()
            }, label: { Text("Quit") })
                .padding()
        }
    }
}
