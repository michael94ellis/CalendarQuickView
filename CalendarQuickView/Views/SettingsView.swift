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
            LaunchAtLogin.Toggle("Launch on Login")
            Toggle("Example Toggle Item", isOn: $showMenuButton)
            Button(action: { AppDelegate.terminate() }, label: { Text("Quit") })
        }
        .frame(width: 480, height: 300)
    }
}
