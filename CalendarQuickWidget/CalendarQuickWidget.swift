//
//  CalendarQuickWidget.swift
//  CalendarQuickWidget
//
//  Created by Michael Ellis on 11/1/21.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), displaySize: context.displaySize)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), displaySize: context.displaySize)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, displaySize: context.displaySize)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    // Size of widget view container
    let displaySize: CGSize
}

@main
struct CalendarQuickWidget: Widget {
    let kind: String = "CalendarQuickWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MonthView()
                .frame(width: entry.displaySize.width, height: entry.displaySize.height)
        }
        .configurationDisplayName("Quick Calendar Widget")
        .description("This is a calendar view widget.")
    }
}



struct MonthView: View {
    let displayDate = Date()
    let calendar = Calendar.current
    let weekDayFormatter = DateFormatter.weekDayFormatter
    let daysInWeek = 7
    
    var body: some View {
        // TODO: Make week able to start on any day of week(customizable)
        let month = displayDate.startOfMonth(using: calendar)
        let days: [[Date]] = makeDays().chunked(into: 7)
        let weekDaysForHeader = days.first ?? []
        return VStack(spacing: 0) {
            // M T W T F S S
            // Weekday Headers
            HStack {
                ForEach(weekDaysForHeader.prefix(daysInWeek), id: \.self) { date in
                    Text(weekDayFormatter.string(from: date))
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 1)
                }
            }
            ForEach(days, id: \.self) { weekDays in
                HStack {
                    ForEach(weekDays, id:\.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            Text(String(self.calendar.component(.day, from: date)))
                                .frame(width: 20, height: 20)
                                .padding(1)
                                .background(calendar.isDateInToday(date) ? Color.green : Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 4.0))
                                .padding(.vertical, 4)
                        } else {
                            Text(String(self.calendar.component(.day, from: date)))
                                .frame(width: 20, height: 20)
                                .padding(1)
                                .background(Color(NSColor.lightGray).opacity(0.18))
                                .clipShape(RoundedRectangle(cornerRadius: 4.0))
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
    
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let sixWeeksFromStart = Calendar.current.date(byAdding: .day, value: 7 * 6, to: monthFirstWeek.start) else {
                  return []
              }
        // get 6 weeks of days
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: sixWeeksFromStart)
        return calendar.generateDays(for: dateInterval)
    }
}
