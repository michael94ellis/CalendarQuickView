//
//  EventSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct EventSettings: View {
    
    @ObservedObject var eventManager = EventKitManager.shared
    
    var body: some View {
        VStack {
            // TODO: Make this into a feature toggle, user should be able to disable/hide EventKit related features from app
            Button(action: {
                self.eventManager.requestAccessToCalendar { success in
                    print("Event access - \(success)")
                }
            },
                   label: {
                HStack {
                    Text("Calendar Access")
                    Image(systemName:  EventKitManager.shared.isAbleToAccessUserCalendar ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(EventKitManager.shared.isAbleToAccessUserCalendar ? .green : .white)
                }
            })
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
