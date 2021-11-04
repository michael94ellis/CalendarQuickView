//
//  SettingsView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/1/21.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    @State var showMenuButton: Bool = true
    
    var body: some View {
        VStack {
            Text("Calendar Quick View Settings")
                .font(.title)
                .padding()
            LaunchAtLogin.Toggle("Launch on Login")
                .padding()
            Button(action: {
                EventKitManager.shared.requestAccessToCalendar() }, label: { Text("Enable Calendar Access") })
                .padding()
            Button(action: { AppDelegate.terminate() }, label: { Text("Quit") })
                .padding()
        }
        .frame(width: 480, height: 300)
    }
}
