//
//  CalendarBody.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import WidgetKit

struct CalendarBody: View {
    
    @ObservedObject var viewModel: CalendarViewModel
    // 175, 245, 294
    var calendarDayCellSize: CGFloat = 25
    var weekDayCellSpacing: CGFloat = 10
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        switch(self.viewModel.calendarSize) {
        case .small:
            self.calendarDayCellSize = 25
        case .medium:
            self.calendarDayCellSize = 30
        case .large:
            self.calendarDayCellSize = 42
        }
    }
    
    // Constants
    private let daysInWeek = 7
    
    // TODO: Make feature where user can change Calendar.Identifier
    
    private var displayMonth: DateInterval {
        viewModel.calendar.dateInterval(of: .month, for: viewModel.displayDate)!
    }
    
    private func weekDayHeaders(for weekDays: [Date]) -> some View {
        let weekDayFormatter = viewModel.weekDayFormatter
        return HStack(spacing: weekDayCellSpacing) {
            ForEach(weekDays, id: \.self) { date in
                Text(weekDayFormatter.string(from: date))
                    .font(viewModel.weekdayHeaderSize)
                    .frame(width: calendarDayCellSize, height: calendarDayCellSize)
            }
        }
        .foregroundColor(Color.text)
    }
    
    var body: some View {
        // TODO: Make week able to start on any day of week(customizable)
        let days: [[Date]] = viewModel.getGetCalendarDays().chunked(into: 7)
        let firstWeek = days.first ?? []
        let month = viewModel.displayDate.startOfMonth(using: viewModel.calendar)
        return VStack(spacing: 0) {
            if viewModel.$showWeekDayHeader.wrappedValue {
                // M T W T F S S
                weekDayHeaders(for: firstWeek)
                    .padding(.vertical, 8)
            }
            // Iterating over the days of the month
            ForEach(days, id: \.self) { weekDays in
                HStack(spacing: weekDayCellSpacing) {
                    ForEach(weekDays, id:\.self) { date in
                        // Each individual day
                        CalendarDay(for: date, size: calendarDayCellSize, displayMonth: month)
                            .environmentObject(viewModel)
                        // Logic to select date
                            .onTapGesture {
                                viewModel.selectedDate = date
                            }
                    }
                }
            }
        }
    }
}
