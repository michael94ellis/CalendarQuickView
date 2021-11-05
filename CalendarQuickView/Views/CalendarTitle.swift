//
//  CalendarTitle.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarTitle: View {
    
    @Binding var displayDate: Date
    let calendar: Calendar
    private let titleFormatter: DateFormatter
    
    init(date: Binding<Date>, calendar: Calendar) {
        self._displayDate = date
        self.calendar = calendar
        self.titleFormatter = DateFormatter(dateFormat: "MMM YY", calendar: calendar)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Month Name "MMM"
            Text(titleFormatter.string(from: displayDate))
                .font(.title)
            Spacer()
            // Previous Month Button
            Button(action: {
                guard let newDate = calendar.date(byAdding: .month, value: -1, to: displayDate) else {
                    return
                }
                withAnimation(.easeOut) {
                    displayDate = newDate
                }
            },
                   label: {
                Label(title: { Text("Previous") },
                      icon: { Image(systemName: "chevron.left") })
                    .labelStyle(IconOnlyLabelStyle())
                    .frame(maxHeight: .infinity)
            })
                .padding(.horizontal, 5)
            // Next Month Button
            Button(action: {
                guard let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) else {
                    return
                }
                withAnimation(.easeIn) {
                    displayDate = newDate
                }
            }, label: {
                Label(title: { Text("Next") },
                      icon: { Image(systemName: "chevron.right") })
                    .labelStyle(IconOnlyLabelStyle())
                    .frame(maxHeight: .infinity)
            })        }
    }
}
