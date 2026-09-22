//
//  CalendarWidget.swift
//  CalendarWidget
//
//  Created by Michael Ellis on 11/19/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    /// How many upcoming day boundaries the timeline covers before WidgetKit asks for more.
    private let upcomingDayCount = 5

    func placeholder(in context: Context) -> CalendarWidgetData {
        CalendarWidgetData(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CalendarWidgetData) -> ()) {
        let entry = CalendarWidgetData(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let calendar = Calendar.current
        let now = Date()
        // The grid only changes when the day changes, so an entry per upcoming midnight
        // is all that is needed. Entries must be strictly ascending and free of
        // duplicates or WidgetKit will not schedule them reliably.
        var entries = [CalendarWidgetData(date: now, configuration: configuration)]
        for dayOffset in 1...upcomingDayCount {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: now) else { continue }
            entries.append(CalendarWidgetData(date: calendar.startOfDay(for: day), configuration: configuration))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CalendarWidgetData: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

@main
struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetCalendarView(date: entry.date)
        }
        .configurationDisplayName("Current Month View")
        .description("This is a calendar view displaying the current month.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
