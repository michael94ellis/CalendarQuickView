//
//  WidgetCalendarView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/20/21.
//

import SwiftUI
import WidgetKit
import ViewModels
import DesignToken

struct WidgetCalendarView: View {

    /// The date of the timeline entry being rendered. WidgetKit renders entries ahead
    /// of time, so the grid and the "today" highlight must come from this rather than
    /// from `Date()`, which would freeze at the moment the timeline was built.
    private let entryDate: Date
    private let weeks: [[Date]]
    private let colorStore = ColorStore()

    init(date: Date) {
        self.entryDate = date
        self.weeks = Self.calendarDays(containing: date).chunked(into: 7)
    }

    var body: some View {
        GeometryReader { parent in
            let cellSize = parent.size.height / 10
            let fontSize: Font = parent.size.height < 200 ? .caption : parent.size.height < 350 ? .body : .title2
            VStack(spacing: 0) {
                Spacer()
                WidgetWeekdayHeader(week: weeks.first ?? [], cellSize: cellSize, fontSize: fontSize)
                    .foregroundColor(colorStore.accentColor)
                ForEach(weeks, id: \.self) { weekDays in
                    HStack(spacing: 4) {
                        Spacer()
                        ForEach(weekDays, id: \.self) { date in
                            // Each individual day
                            CalendarDay(date: date,
                                        fontSize: fontSize,
                                        cellSize: cellSize,
                                        dayShape: DayDisplayShape.roundedSquare.shape,
                                        month: entryDate,
                                        referenceDate: entryDate)
                                .padding(.vertical, 2)
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
        }
        .widgetContainerBackground(colorStore.surfaceColor)
    }

    /// Generates 6 weeks worth of days covering the month that contains `date`.
    static func calendarDays(containing date: Date) -> [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: date),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let sixWeeksFromStart = Calendar.current.date(byAdding: .day, value: 7 * 6, to: monthFirstWeek.start) else {
                  return []
              }
        // get 6 weeks of days
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: sixWeeksFromStart)
        return Calendar.current.generateDays(for: dateInterval)
    }

}

/// The single-letter weekday row above the grid.
private struct WidgetWeekdayHeader: View {

    let week: [Date]
    let cellSize: CGFloat
    let fontSize: Font

    private let weekDayFormatter = DateFormatter.weekDayFormatter

    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            ForEach(week, id: \.self) { date in
                Text(weekDayFormatter.string(from: date))
                    .frame(width: cellSize, height: cellSize)
                    .font(fontSize)
            }
            Spacer()
        }
    }
}

private extension View {
    /// macOS 14 requires widget content to declare its background through
    /// `containerBackground`; without it the system renders the widget incorrectly.
    @ViewBuilder
    func widgetContainerBackground(_ color: Color) -> some View {
        if #available(macOS 14.0, *) {
            self.containerBackground(color, for: .widget)
        } else {
            self.background(color)
        }
    }
}
