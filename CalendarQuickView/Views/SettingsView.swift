//
//  SettingsView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/1/21.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    
    var windowRef: NSWindow
    @State var showMenuButton: Bool = true
    @ObservedObject var eventManager = EventKitManager.shared
    
    var body: some View {
        VStack {
            Text("Calendar Quick View Settings")
                .font(.title)
                .padding()
            HStack {
                // Labels
                VStack(alignment: .trailing, spacing: 10) {
                    Text("Launch on Login")
                    Text("Calendar Access") 
                }
                // Controls
                VStack(alignment: .leading, spacing: 10) {
                    LaunchAtLogin.Toggle("")
                    Button(action: {
                        eventManager.requestAccessToCalendar { success in
                            print("Event access - \(success)")
                            windowRef.orderFrontRegardless()
                            windowRef.makeKey()
                        }
                    },
                           label: { Image(systemName:  EventKitManager.shared.isAbleToAccessUserCalendar ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(EventKitManager.shared.isAbleToAccessUserCalendar ? .green : .white)
                    })
                }
            }
            // Quit Button
            Button(action: {
                // FIXME: takes 2 clicks to close, should only take 1 even if it has to have a delay
                AppDelegate.terminate()
            }, label: { Text("Quit") })
                .padding()
            Spacer()
        }
        .frame(width: 480, height: 300)
        Spacer()
    }
}
