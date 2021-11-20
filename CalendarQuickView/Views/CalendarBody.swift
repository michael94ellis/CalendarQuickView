//
//  CalendarBody.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import WidgetKit

struct CalendarBody: View {
    // TODO: Remove this - make it more reusable
    // Constants
    private let daysInWeek: Int = 7
    private let weekDayCellSpacing: CGFloat = 10
    private let verticalPadding: CGFloat = 8
    private let days: [[Date]]
    private let fontSize: Font
    private let dayCellSize: CGFloat
    private let titleTextColor: Color
    private let showWeekdayHeaderRow: Bool
    private let displayMonth: Date
    private let dayShape: DayDisplayShape
    
    init(viewModel: CalendarViewModel) {
        self.dayCellSize = viewModel.getDayCellSize
        self.fontSize = viewModel.calendarSize == .small ? .body : viewModel.calendarSize == .medium ? .title3 : .title2
        self.titleTextColor = ColorStore.shared.titleTextColor
        self.days = viewModel.getGetCalendarDays().chunked(into: 7)
        self.showWeekdayHeaderRow = viewModel.showWeekDayHeader
        self.displayMonth = viewModel.displayDate.startOfMonth(using: viewModel.calendar)
        self.dayShape = viewModel.dayDisplayShape
    }
        
    private func weekDayHeaders(for weekDays: [Date]) -> some View {
        let weekDayFormatter = DateFormatter.weekDayFormatter
        return HStack(spacing: weekDayCellSpacing) {
            ForEach(weekDays, id: \.self) { date in
                Text(weekDayFormatter.string(from: date))
                    .font(self.fontSize)
                    .frame(width: self.dayCellSize, height: self.dayCellSize)
            }
        }
        .foregroundColor(self.titleTextColor)
    }
    
    var body: some View {
        // TODO: Make week able to start on any day of week(customizable)
        return VStack(spacing: 0) {
            if self.showWeekdayHeaderRow {
                // M T W T F S S
                weekDayHeaders(for: days.first ?? [])
                    .padding(.vertical, verticalPadding)
            }
            // Iterating over the days of the month
            ForEach(days, id: \.self) { weekDays in
                HStack(spacing: weekDayCellSpacing) {
                    ForEach(weekDays, id:\.self) { date in
                        // Each individual day
                        CalendarDay(date: date,
                                    fontSize: self.fontSize,
                                    cellSize: self.dayCellSize,
                                    dayShape: self.dayShape,
                                    month: self.displayMonth)
                    }
                }
            }
        }
        .padding(.top, verticalPadding)
    }
}
