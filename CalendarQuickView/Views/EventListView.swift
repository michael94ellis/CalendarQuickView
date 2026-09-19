//
//  EventListView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/7/21.
//

import AppKit
import SwiftUI
import EventKit
import ViewModels

struct EventListView: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    @EnvironmentObject private var eventManager: EventKitManager
    @State private var joinErrorMessage: String?

    /// Row height used for layout and menu sizing.
    static let rowHeight: CGFloat = 30
    /// Visible rows before the list scrolls.
    static let maxVisibleRows = 5
    /// Fixed slot height so the status-menu host does not resize when the selected day changes.
    static let slotHeight: CGFloat = 4 * rowHeight

    private var eventsToShow: [EKEvent] {
        Array(
            eventManager.events(on: viewModel.selectedDate)
        )
    }
    
    var body: some View {
        let fontSize: Font = viewModel.calendarSize == .small ? .callout : viewModel.calendarSize == .medium ? .body : .title3
        if eventManager.isEventFeatureEnabled, eventManager.hasCalendarReadAccess {
            // Color.clear owns the height for NSHostingView fittingSize; an empty ScrollView
            // alone often reports ~0 and the menu is measured too short for later days.
            Color.clear
                .frame(height: Self.slotHeight)
                .overlay(alignment: .top) {
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
                                        if event.meetingURL != nil {
                                            Button {
                                                joinCall(for: event)
                                            } label: {
                                                Image(systemName: "video.fill")
                                                    .font(fontSize)
                                            }
                                            .buttonStyle(.plain)
                                            .foregroundColor(event.calendarColor)
                                            .help("Join video call")
                                        }
                                        Text(viewModel.eventDateFormatter.string(from: event.startDate))
                                            .font(fontSize)
                                            .foregroundColor(event.calendarColor)
                                            .opacity(0.85)
                                    }
                                    .frame(height: Self.rowHeight - 1)
                                    Divider()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                }
                // Overlaid rather than stacked below: anything that grows this view changes the
                // popup's height, which NSMenu cannot re-measure once it is open.
                .overlay(alignment: .bottom) {
                    if let joinErrorMessage {
                        Text(joinErrorMessage)
                            .font(.caption2)
                            .foregroundColor(.red)
                            .lineLimit(2)
                            .padding(4)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                    }
                }
                .clipped()
                .onAppear {
                    eventManager.fetchEvents()
                }
        }
    }

    private func joinCall(for event: EKEvent) {
        guard let url = event.meetingURL else { return }
        joinErrorMessage = nil
        if !NSWorkspace.shared.open(url) {
            joinErrorMessage = "Couldn't open the meeting link for \"\(event.title ?? "this event")\"."
        }
    }
}
