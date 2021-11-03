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
    
    @State var displayDate: Date
    
    private var calendar: Calendar
    private let monthFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    
    // Constants
    private let daysInWeek = 7
    
    init() {
        self._displayDate = State(wrappedValue: Date())
        self.calendar = Calendar(identifier: .iso8601)
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "dd", calendar: calendar)
    }
    
    private var displayMonth: DateInterval {
        calendar.dateInterval(of: .month, for: displayDate)!
    }
    
    private var titleView: some View {
        HStack {
            Button(action: {
                guard let newDate = calendar.date(byAdding: .month, value: -1, to: displayDate) else {
                    return
                }
                displayDate = newDate
            },
                   label: {
                Label(title: { Text("Previous") }, icon: { Image(systemName: "chevron.left") })
                    .labelStyle(IconOnlyLabelStyle())
                    .frame(maxHeight: .infinity)
            })
                .frame(width: 65)
            Spacer()
            Text(monthFormatter.string(from: displayDate))
                .font(.headline)
                .padding()
            Spacer()
            Button(action: {
                guard let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) else {
                    return
                }
                displayDate = newDate
            }, label: {
                Label(title: { Text("Next") }, icon: { Image(systemName: "chevron.right") })
                    .labelStyle(IconOnlyLabelStyle())
                    .frame(maxHeight: .infinity)
            })
                .frame(width: 65)
        }
    }
    
    var body: some View {
        let month = displayDate.startOfMonth(using: calendar)
        let days = makeDays()
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                Section(header: titleView, content: {
                    ForEach(days.prefix(daysInWeek), id: \.self) { date in
                        Text(weekDayFormatter.string(from: date))
                    }
                    ForEach(days, id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            Text(String(self.calendar.component(.day, from: date)))
                                .frame(width: 20, height: 20)
                                .padding(1)
                                .background(Color.blue.opacity(0.88))
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
                })
            }
            Spacer()
            Button(action: { self.openSettingsWindow() }, label: { Text("Open Settings") })
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
