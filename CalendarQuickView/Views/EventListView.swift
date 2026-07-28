//
//  EventListView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/7/21.
//

import SwiftUI
import EventKit
import ViewModels

struct EventListView: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    @EnvironmentObject private var eventManager: EventKitManager
    
    /// Row height used for layout and menu sizing.
    static let rowHeight: CGFloat = 30
    /// Visible rows before the list scrolls.
    static let maxVisibleRows = 5
    
    private var eventsToShow: [EKEvent] {
        Array(
            eventManager.events(on: viewModel.selectedDate)
                .prefix(Int(eventManager.numOfEventsToDisplay))
        )
    }
    
    private var listHeight: CGFloat {
        CGFloat(min(eventsToShow.count, Self.maxVisibleRows)) * Self.rowHeight
    }
    
    var body: some View {
        let fontSize: Font = viewModel.calendarSize == .small ? .callout : viewModel.calendarSize == .medium ? .body : .title3
        if eventManager.isEventFeatureEnabled, eventManager.hasCalendarReadAccess, !eventsToShow.isEmpty {
            ScrollView(.vertical, showsIndicators: eventsToShow.count > Self.maxVisibleRows) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(eventsToShow.enumerated()), id: \.offset) { _, event in
                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 1)
                                .fill(event.calendarColor)
                                .frame(width: 3, height: 18)
                            Text(event.title ?? "Untitled")
                                .font(fontSize)
                                .foregroundColor(event.calendarColor)
                                .lineLimit(1)
                            Spacer(minLength: 4)
                            Text(viewModel.eventDateFormatter.string(from: event.startDate))
                                .font(fontSize)
                                .foregroundColor(event.calendarColor)
                                .opacity(0.85)
                        }
                        .frame(height: Self.rowHeight - 1)
                        Divider()
                    }
                }
            }
            .frame(height: listHeight)
            .onAppear {
                eventManager.fetchEvents()
            }
        }
    }
}
