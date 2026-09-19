//
//  ReminderListView.swift
//  CalendarQuickView
//

import SwiftUI
import EventKit
import ViewModels

/// Shows reminders due on the selected day, with a checkbox to mark them complete.
struct ReminderListView: View {

    @EnvironmentObject var viewModel: CalendarViewModel
    @EnvironmentObject private var eventManager: EventKitManager

    /// Fixed slot height, for the same reason as `EventListView`: the status menu measures its
    /// content once when it opens, so the number of reminders on the selected day must not
    /// change the popup's height.
    static let slotHeight: CGFloat = 2 * EventListView.rowHeight

    private var remindersToShow: [EKReminder] {
        eventManager.reminders(on: viewModel.selectedDate)
    }

    var body: some View {
        let fontSize: Font = viewModel.calendarSize == .small ? .callout : viewModel.calendarSize == .medium ? .body : .title3
        if eventManager.isRemindersFeatureEnabled, eventManager.hasReminderReadAccess {
            Color.clear
                .frame(height: Self.slotHeight)
                .overlay(alignment: .top) {
                    if remindersToShow.isEmpty {
                        Text("No reminders due")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 6)
                    } else {
                        ScrollView(.vertical, showsIndicators: remindersToShow.count > 2) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(remindersToShow, id: \.calendarItemIdentifier) { reminder in
                                    HStack(spacing: 6) {
                                        Button {
                                            eventManager.setReminderCompleted(reminder, completed: true)
                                        } label: {
                                            Image(systemName: "circle")
                                        }
                                        .buttonStyle(.plain)
                                        Text(reminder.title ?? "Untitled Reminder")
                                            .font(fontSize)
                                            .lineLimit(1)
                                        Spacer(minLength: 4)
                                    }
                                    .frame(height: EventListView.rowHeight - 1)
                                    Divider()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .clipped()
                .onAppear {
                    eventManager.fetchReminders()
                }
        }
    }
}
