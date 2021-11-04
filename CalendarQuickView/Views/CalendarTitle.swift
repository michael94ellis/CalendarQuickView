//
//  CalendarTitle.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarTitle: View {
    
    @State var displayDate: Date = Date()
    @State var todaysDate: Date = Date()
    let calendar: Calendar
    private let monthFormatter: DateFormatter
    
    init(date: Date, calendar: Calendar) {
        self._displayDate = State(wrappedValue: date)
        self._todaysDate = State(wrappedValue: date)
        self.calendar = calendar
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
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
                
                Button(action: {
                    
                    displayDate = todaysDate
                }, label: {
                    Label(title: { Text("Today") }, icon: { Image(systemName: "chevron.right") })
                        .labelStyle(TitleOnlyLabelStyle())
                        .frame(maxHeight: .infinity)
                })
                    .frame(width: 65)
                
                
                
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
            Text(monthFormatter.string(from: displayDate))
                .font(.headline)
                .padding()
        }
    }
}
