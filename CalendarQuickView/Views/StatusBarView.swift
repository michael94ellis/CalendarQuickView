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
    
    @State var displayDate: Date = Date()
    
    private var calendar: Calendar
    private let monthFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    
    // Constants
    private let daysInWeek = 7
    
    init() {
        self.calendar = Calendar(identifier: .iso8601)
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "dd", calendar: calendar)
    }
    
    private var displayMonth: DateInterval {
        calendar.dateInterval(of: .month, for: displayDate)!
    }
    
    var body: some View {
        let month = displayDate.startOfMonth(using: calendar)
        let days = makeDays()
        return VStack {
            CalendarTitle(date: _displayDate, calendar: calendar)
            LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                // M T W T F S S
                // Weekday Headers
                ForEach(days.prefix(daysInWeek), id: \.self) { date in
                    Text(weekDayFormatter.string(from: date))
                }
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        Text(String(self.calendar.component(.day, from: date)))
                            .frame(width: 20, height: 20)
                            .padding(1)
                            .background(calendar.isDateInToday(date) ? Color.green : Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                            .padding(.vertical, 4)
                    } else {
                        Text(String(self.calendar.component(.day, from: date)))
                            .frame(width: 20, height: 20)
                            .padding(1)
                            .background(Color(NSColor.lightGray).opacity(0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                            .padding(.vertical, 4)
                    }
                }
            }
            .padding(.horizontal, 10)
            Spacer()
            Button(action: { self.openSettingsWindow() }, label: { Text("Open Settings") })
                .padding(.bottom, 10)
        }
    }
    
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
    
    func openSettingsWindow() {
        var windowRef:NSWindow
        windowRef = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 100, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        windowRef.setFrameAutosaveName("Calendar Quick View Settings")
        windowRef.isReleasedWhenClosed = false
        windowRef.contentView = NSHostingView(rootView: SettingsView())
        windowRef.makeKey()
        windowRef.orderFrontRegardless()
    }
}
