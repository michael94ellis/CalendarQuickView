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
    func placeholder(in context: Context) -> CalendarWidgetData {
        CalendarWidgetData(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CalendarWidgetData) -> ()) {
        let entry = CalendarWidgetData(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CalendarWidgetData] = []

        let currentDate = Date()
        // Current time and Current time + 1 hour
        for hourOffset in 0 ..< 2 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CalendarWidgetData(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        // Today and the next 4 days
        for dayOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let entry = CalendarWidgetData(date: entryDate, configuration: configuration)
            entries.append(entry)
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
            WidgetCalendarView()
        }
        .configurationDisplayName("Current Month View")
        .description("This is a calendar view displaying the current month.")
    }
}
