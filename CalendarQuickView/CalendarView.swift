//
//  CalendarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 10/29/21.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval

    private var month: Date {
        let dayComponent = DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        guard let month = calendar.generateDates(inside: interval, matching: dayComponent).first else {
            return Date()
        }
        return month
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(DateFormatter.monthAndYear.string(from: month))
                    .font(.title)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                Spacer()
            }
            MonthView(month: month)
                .padding(.horizontal, 12)
        }
    }
}
