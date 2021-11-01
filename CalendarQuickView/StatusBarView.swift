//
//  StatusBarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI
import AppKit
import LaunchAtLogin

struct StatusBarView: View {
    @Environment(\.calendar) var calendar
    
    @State var displayDate: Date
    
    init() {
        self._displayDate = State(wrappedValue: Date())
    }
    
    private var displayMonth: DateInterval {
        calendar.dateInterval(of: .month, for: displayDate)!
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Prev") {
                    displayDate = displayDate.addMonths(-1)
                }
                Spacer()
                Button("Next") {
                    displayDate = displayDate.addMonths(1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            CalendarView(interval: displayMonth)
                .frame(width: 200, height: 220, alignment: .top)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            LaunchAtLogin.Toggle("Launch on Login")
        }
    }
}
