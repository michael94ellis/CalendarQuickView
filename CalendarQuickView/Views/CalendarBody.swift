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
    // 175, 245, 294
    var calendarDayCellSize: CGFloat = 25
    var weekDayCellSpacing: CGFloat = 10
    
    var dayShape: some Shape {
        switch(viewModel.dayDisplayShape) {
        case .roundedSquare:
            return AnyShape(RoundedRectangle(cornerRadius: 4))
        case .circle:
            return AnyShape(Circle())
        case .square:
            return AnyShape(Rectangle())
        case .none:
            return AnyShape(Rectangle())
        }
    }
    
    init() {
        switch(viewModel.calendarSize) {
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
    // MARK: - View Representing Each Day
    /// This will do the required info gathering to create a Day view
    private func createDayNumberView(for date: Date, displayMonth: Date) -> some View {
        let backgroundColor: Color
        let textColor: Color
        if viewModel.calendar.isDate(date, inSameDayAs: viewModel.selectedDate) {
            // Selected Day
            backgroundColor = viewModel.selectedDayBGColor
            textColor = viewModel.selectedDayTextColor
        } else if viewModel.calendar.isDateInToday(date) {
            // Current Day
            backgroundColor = viewModel.currentDayBGColor
            textColor = viewModel.currentDayTextColor
        } else if viewModel.calendar.isDate(date, equalTo: displayMonth, toGranularity: .month) {
            // Day in Current Displayed Month
            backgroundColor = viewModel.currentMonthDaysBGColor
            textColor = viewModel.currentMonthDaysTextColor
        } else if date < viewModel.displayDate {
            // Day is before Current Displayed Month
            backgroundColor = viewModel.prevMonthDaysBGColor
            textColor = viewModel.prevMonthDaysTextColor
        } else {
            // Day is after Current Displayed Month
            backgroundColor = viewModel.nextMonthDaysBGColor
            textColor = viewModel.nextMonthDaysTextColor
        }
        return Text(String(viewModel.calendar.component(.day, from: date)))
            .frame(width: calendarDayCellSize, height: calendarDayCellSize)
            .foregroundColor(textColor)
            .background(backgroundColor)
            .if(viewModel.dayDisplayShape != .none) { textView in
                textView.clipShape(dayShape)
            }
            .padding(.vertical, 4)
    }
    
    private func weekDayHeaders(for weekDays: [Date]) -> some View {
        let fontSize: Font = viewModel.calendarSize == .small ? .body : viewModel.calendarSize == .medium ? .title3 : .title2
        let weekDayFormatter = viewModel.weekDayFormatter
        return HStack(spacing: weekDayCellSpacing) {
            ForEach(weekDays, id: \.self) { date in
                Text(weekDayFormatter.string(from: date))
                    .font(fontSize)
                    .frame(width: calendarDayCellSize, height: calendarDayCellSize)
            }
        }
        .foregroundColor(viewModel.weekdayHeaderTextColor)
        .background(viewModel.weekDayHeaderBGColor)
        .clipShape(RoundedRectangle(cornerRadius: 4.0))
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
                        createDayNumberView(for: date, displayMonth: month)
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
