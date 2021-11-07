//
//  CalendarBody.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import WidgetKit

struct CalendarBody: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared

    private let monthFormatter = DateFormatter.monthFormatter
    private let weekDayFormatter = DateFormatter.weekDayFormatter
    private let dayFormatter = DateFormatter.dayFormatter
    // 175, 245, 294
    var calendarDayCellSize: CGFloat = 25
    var weekDayCellSpacing: CGFloat = 10
    
    init() {
        switch(viewModel.calendarSize) {
        case .small:
            self.weekDayCellSpacing = 10
            self.calendarDayCellSize = 25
        case .medium:
            self.weekDayCellSpacing = 10
            self.calendarDayCellSize = 30
        case .large:
            self.weekDayCellSpacing = 10
            self.calendarDayCellSize = 42
        }
    }
    
    // Constants
    private let daysInWeek = 7
    
    // TODO: Make feature where user can change Calendar.Identifier
    
    private var displayMonth: DateInterval {
        viewModel.calendar.dateInterval(of: .month, for: viewModel.displayDate)!
    }
    // MARK: - View Representing Each Day
    /// This will do the required info gathering to create a Day view
    private func createDayNumberView(_ date: Date) -> some View {
        let month = viewModel.displayDate.startOfMonth(using: viewModel.calendar)
        let backgroundColor: Color
        if viewModel.calendar.isDate(date, inSameDayAs: viewModel.selectedDate) {
            // Selected Day
            backgroundColor = viewModel.selectedDayColor
        } else if viewModel.calendar.isDateInToday(date) {
            // Current Day
            backgroundColor = viewModel.currentDayColor
        } else if viewModel.calendar.isDate(date, equalTo: month, toGranularity: .month) {
            // Day in Current Displayed Month
            backgroundColor = viewModel.currentMonthDaysColor
        } else if date < viewModel.displayDate {
            // Day is before Current Displayed Month
            backgroundColor = viewModel.prevMonthDaysColor
        } else {
            // Day is after Current Displayed Month
            backgroundColor = viewModel.nextMonthDaysColor
        }
        return Text(String(viewModel.calendar.component(.day, from: date)))
            .frame(width: calendarDayCellSize, height: calendarDayCellSize)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4.0))
            .padding(.vertical, 4)
    }
    
    private func weekDayHeaders(for weekDays: [Date]) -> some View {
        let fontSize: Font = viewModel.calendarSize == .small ? .body : viewModel.calendarSize == .medium ? .title3 : .title2
        return HStack(spacing: weekDayCellSpacing) {
            ForEach(weekDays.prefix(daysInWeek), id: \.self) { date in
                Text(weekDayFormatter.string(from: date))
                    .font(fontSize)
                    .frame(width: calendarDayCellSize, height: calendarDayCellSize)
            }
        }
        .background(viewModel.weekDayHeaderColor)
        .clipShape(RoundedRectangle(cornerRadius: 4.0))
    }
    
    var body: some View {
        // TODO: Make week able to start on any day of week(customizable)
        let days: [[Date]] = viewModel.getGetCalendarDays().chunked(into: 7)
        let firstWeek = days.first ?? []
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
                        createDayNumberView(date)
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
