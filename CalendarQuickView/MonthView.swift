//
//  MonthView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let month: Date
    let content: (Date) -> DateView

    init(
        month: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    
    var body: some View {
        VStack {
            Text(DateFormatter.monthAndYear.string(from: month))
                .font(.title)
                .padding(.vertical, 5)
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}
