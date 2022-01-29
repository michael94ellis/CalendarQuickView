//
//  EventKitWrapper.swift
//  TimeDraw
//
//  Created by Michael Ellis on 1/4/22.
//

import Foundation
import SwiftUI
import EventKit

/// Swift wrapper for EventKit
public final class EventManager: ObservableObject {

    // MARK: - Properties
    @Published public var events = [EKEvent]()
    @Published public var reminders = [EKReminder]()

    public static var appName: String?

    /// Event store: An object that accesses the user’s calendar and reminder events and supports the scheduling of new events.
    public private(set) var eventStore = EKEventStore()

    /// Returns calendar object from event kit
    public var defaultEventCalendar: EKCalendar? {
        eventStore.calendarForEvents()
    }
    /// Returns calendar object from event kit
    public var defaultReminderCalendar: EKCalendar? {
        eventStore.calendarForReminders()
    }

    // MARK: Static accessor
    public static let shared = EventManager()

    public static func configureWithAppName(_ appName: String) {
        self.appName = appName
    }

    private init() {} // This prevents others from using the default '()' initializer for this class.
    // MARK: - Flow
    /// Request event store authorization for Events
    /// - Returns: EKAuthorizationStatus enum
    public func requestEventStoreAuthorization() async throws -> EKAuthorizationStatus {
        let granted = try await requestEventAccess()
        if granted {
            return EKEventStore.authorizationStatus(for: .event)
        }
        else {
            throw EventError.unableToAccessCalendar
        }
    }
    /// Request event store authorization for Reminders
    /// - Returns: EKAuthorizationStatus enum
    public func requestReminderStoreAuthorization() async throws -> EKAuthorizationStatus {
        let granted = try await requestReminderAccess()
        if granted {
            return EKEventStore.authorizationStatus(for: .event)
        }
        else {
            throw EventError.unableToAccessCalendar
        }
    }
    
    // MARK: - CRUD
    /// Create an event
    /// - Parameters:
    ///   - title: title of the event
    ///   - startDate: event's start date
    ///   - endDate: event's end date
    ///   - span: event's span
    ///   - isAllDay: is all day event
    /// - Returns: created event
    public func createEvent(
        _ title: String,
        startDate: Date,
        endDate: Date?,
        span: EKSpan = .thisEvent,
        isAllDay: Bool = false
    ) async throws -> EKEvent {
        let calendar = try await accessEventsCalendar()
        let createdEvent = try self.eventStore.createEvent(title: title, startDate: startDate, endDate: endDate, calendar: calendar, span: span, isAllDay: isAllDay)
        return createdEvent
    }
    
    /// Create a Reminder
    /// - Parameters:
    ///   - title: title of the reminder
    /// - Returns: created reminder
    public func createReminder(
        _ title: String,
        startDate: DateComponents?,
        dueDate: DateComponents?
    ) async throws -> EKReminder {
        self.eventStore.calendars(for: .reminder)
        let calendar = try await accessRemindersCalendar()
        let newReminder = try self.eventStore.createReminder(title: title, startDate: startDate, dueDate: dueDate, calendar: calendar)
        return newReminder
    }

    /// Delete an event
    /// - Parameters:
    ///   - identifier: event identifier
    ///   - span: even't span
    public func deleteEvent(
        identifier: String,
        span: EKSpan = .thisEvent
    ) async throws {
        try await accessEventsCalendar()
        try self.eventStore.deleteEvent(identifier: identifier, span: span)
    }

    // MARK: - Fetch Events
    /// Fetch events for today
    /// - Parameter completion: completion handler
    /// - Parameter filterCalendarIDs: filterable Calendar IDs
    /// Returns: events for today
    @discardableResult
    public func fetchEventsForToday(filterCalendarIDs: [String] = []) async throws -> [EKEvent] {
        let today = Date()
        return try await fetchEvents(startDate: today.startOfDay, endDate: today.endOfDay, filterCalendarIDs: filterCalendarIDs)
    }

    /// Fetch events for a specific day
    /// - Parameters:
    ///   - date: day to fetch events from
    ///   - completion: completion handler
    ///   - filterCalendarIDs: filterable Calendar IDs
    /// Returns: events
    @discardableResult
    public func fetchEvents(for date: Date, filterCalendarIDs: [String] = []) async throws -> [EKEvent] {
        try await fetchEvents(startDate: date.startOfDay, endDate: date.endOfDay, filterCalendarIDs: filterCalendarIDs)
    }

    /// Fetch events for a specific day
    /// - Parameters:
    ///   - date: day to fetch events from
    ///   - completion: completion handler
    ///   - startDate: event start date
    ///   - filterCalendarIDs: filterable Calendar IDs
    /// Returns: events
    @discardableResult
    public func fetchEventsRangeUntilEndOfDay(from startDate: Date, filterCalendarIDs: [String] = []) async throws -> [EKEvent] {
        try await fetchEvents(startDate: startDate, endDate: startDate.endOfDay, filterCalendarIDs: filterCalendarIDs)
    }
    
    /// Fetch events from date range
    /// - Parameters:
    ///   - startDate: start date range
    ///   - endDate: end date range
    ///   - completion: completion handler
    ///   - filterCalendarIDs: filterable Calendar IDs
    /// Returns: events
    @discardableResult
    public func fetchEvents(startDate: Date, endDate: Date, filterCalendarIDs: [String] = []) async throws -> [EKEvent] {
        let authorization = try await requestEventStoreAuthorization()
        guard authorization == .authorized else {
            throw EventError.eventAuthorizationStatus(nil)
        }

        let calendars = self.eventStore.calendars(for: .event).filter { calendar in
            if filterCalendarIDs.isEmpty { return true }
            return filterCalendarIDs.contains(calendar.calendarIdentifier)
        }

        let predicate = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = self.eventStore
            .events(matching: predicate)
            .uniqued(\.eventIdentifier) // filter duplicated events
        // MainActor is a type that runs code on main thread.
        await MainActor.run {
            self.events = events
        }

        return events
    }
    
    /// Fetch events from date range
    /// - Parameters:
    ///   - startDate: start date range
    ///   - endDate: end date range
    ///   - completion: completion handler
    ///   - filterCalendarIDs: filterable Calendar IDs
    /// Returns: events
    public func fetchReminders(filterCalendarIDs: [String] = []) async throws {
        let authorization = try await requestReminderStoreAuthorization()
        guard authorization == .authorized else {
            throw EventError.eventAuthorizationStatus(nil)
        }
        let calendars = self.eventStore.calendars(for: .reminder).filter { calendar in
            if filterCalendarIDs.isEmpty { return true }
            return filterCalendarIDs.contains(calendar.calendarIdentifier)
        }
        let predicate = self.eventStore.predicateForReminders(in: calendars)
        self.eventStore
            .fetchReminders(matching: predicate) { newReminders in
                DispatchQueue.main.async {
                    print(newReminders)
                    self.reminders = newReminders ?? []
                }
            }
    }

    // MARK: Private
    /// Request access to Events calendar
    /// - Returns: calendar object
    @discardableResult
    private func accessEventsCalendar() async throws -> EKCalendar {
        let authorization = try await requestEventStoreAuthorization()

        guard authorization == .authorized else {
            throw EventError.eventAuthorizationStatus(nil)
        }

        guard let calendar = eventStore.calendarForEvents() else {
            throw EventError.unableToAccessCalendar
        }

        return calendar
    }
    /// Request access to Reminders calendar
    /// - Returns: calendar object
    @discardableResult
    private func accessRemindersCalendar() async throws -> EKCalendar {
        let authorization = try await requestReminderStoreAuthorization()

        guard authorization == .authorized else {
            throw EventError.eventAuthorizationStatus(nil)
        }

        guard let calendar = eventStore.calendarForReminders() else {
            throw EventError.unableToAccessCalendar
        }

        return calendar
    }
    
    private func requestEventAccess() async throws -> Bool {
        try await eventStore.requestAccess(to: .event)
    }
    
    private func requestReminderAccess() async throws -> Bool {
        try await eventStore.requestAccess(to: .reminder)
    }
}
