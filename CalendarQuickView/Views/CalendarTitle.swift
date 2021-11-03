//
//  CalendarTitle.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarTitle: View {
    
    @State var displayDate: Date = Date()
    let calendar: Calendar
    private let monthFormatter: DateFormatter
    
    init(date: State<Date>, calendar: Calendar) {
        self._displayDate = date
        self.calendar = calendar
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(monthFormatter.string(from: displayDate))
                .font(.headline)
                .padding()
            Spacer()
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
}
