//
//  CalendarWidget.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
            completion(SimpleEntry())
    }
}

//struct SimpleEntry: TimelineEntry {
//    
//}

@main
struct Calendar_Widget: Widget {
    private let kind: String = "Calendar_Widget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider(),
            content: { entry in
                Text("YOYOY")
            })
            .configurationDisplayName("Random Emoji")
            .description("Display a widget with an emoji that is updated randomly.")
            .supportedFamilies([.systemSmall])
    }
}
