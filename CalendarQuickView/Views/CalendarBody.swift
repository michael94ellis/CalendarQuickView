//
//  CalendarBody.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import WidgetKit

struct CalendarBody: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    
    private let weekDayCellSpacing: CGFloat = 10
    private let verticalPadding: CGFloat = 8
    
    private var dayCellSize: CGFloat { viewModel.getDayCellSize }
    private var fontSize: Font {
        viewModel.calendarSize == .small ? .body : viewModel.calendarSize == .medium ? .title3 : .title2
    }
    private var days: [[Date]] {
        viewModel.getGetCalendarDays().chunked(into: 7)
    }
    private var displayMonth: Date {
        viewModel.displayDate.startOfMonth(using: viewModel.calendar)
    }
        
    private func weekDayHeaders(for weekDays: [Date]) -> some View {
        let weekDayFormatter = DateFormatter.weekDayFormatter
        return HStack(spacing: weekDayCellSpacing) {
            ForEach(weekDays, id: \.self) { date in
                Text(weekDayFormatter.string(from: date))
                    .font(fontSize)
                    .frame(width: dayCellSize, height: dayCellSize)
            }
        }
        .foregroundColor(ColorStore.shared.accentColor)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.showWeekDayHeader {
                weekDayHeaders(for: days.first ?? [])
                    .padding(.vertical, verticalPadding)
            }
            ForEach(days, id: \.self) { weekDays in
                HStack(spacing: weekDayCellSpacing) {
                    ForEach(weekDays, id: \.self) { date in
                        CalendarDay(
                            date: date,
                            fontSize: fontSize,
                            cellSize: dayCellSize,
                            dayShape: viewModel.dayDisplayShape.shape,
                            month: displayMonth,
                            isSelected: viewModel.calendar.isDate(date, inSameDayAs: viewModel.selectedDate),
                            isSelectable: true,
                            onSelect: { viewModel.selectDate(date) },
                            eventColors: EventKitManager.shared.calendarColors(on: date)
                        )
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(.top, verticalPadding)
    }
}
