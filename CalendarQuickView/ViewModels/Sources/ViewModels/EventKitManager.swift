//
//  EventKitManager.swift
//  CalendarQuickView
//
//  Created by David Malicke on 11/1/21.
//

import Foundation
import EventKit
import AppKit
import SwiftUI

public enum EventCreationError: LocalizedError, Equatable {
    case emptyTitle
    case invalidDateRange
    case noAccess
    case noWritableCalendar
    case saveFailed(String)

    public var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Please enter a title for the event."
        case .invalidDateRange:
            return "End time must be after the start time."
        case .noAccess:
            return "Calendar access isn't granted. Check Calendar Access in the Events tab."
        case .noWritableCalendar:
            return "No writable calendar is available to add this event to."
        case .saveFailed(let message):
            return "Couldn't save the event: \(message)"
        }
    }
}

public enum ReminderCreationError: LocalizedError, Equatable {
    case emptyTitle
    case noAccess
    case noWritableList
    case saveFailed(String)

    public var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Please enter a title for the reminder."
        case .noAccess:
            return "Reminders access isn't granted. Check Reminders Access in the Events tab."
        case .noWritableList:
            return "No writable reminder list is available to add this reminder to."
        case .saveFailed(let message):
            return "Couldn't save the reminder: \(message)"
        }
    }
}

public final class EventKitManager: ObservableObject {
    
    @AppStorage(AppStorageKeys.calendarAccessGranted) public var isAbleToAccessUserCalendar: Bool = false
    @AppStorage(AppStorageKeys.isEventFeatureEnabled) public var isEventFeatureEnabled: Bool = false
    @AppStorage(AppStorageKeys.hiddenCalendarIdentifiers) private var hiddenCalendarIdentifiersRaw: String = ""
    @AppStorage(AppStorageKeys.isRemindersFeatureEnabled) public var isRemindersFeatureEnabled: Bool = false

    @Published public private(set) var titles: [String] = []
    @Published public private(set) var startDates: [Date] = []
    @Published public private(set) var endDates: [Date] = []
    @Published public private(set) var events: [EKEvent] = []
    @Published public private(set) var futureEvents: [EKEvent] = []
    @Published public private(set) var eventCalendars: [EKCalendar] = []
    @Published public private(set) var reminderCalendars: [EKCalendar] = []
    /// Incomplete reminders, refreshed by `fetchReminders()`.
    @Published public private(set) var reminders: [EKReminder] = []

    let eventStore = EKEventStore()
    
    public init() {}
    
    /// Live EventKit authorization — prefer this over the persisted AppStorage flag.
    public var hasCalendarReadAccess: Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        if #available(macOS 14.0, *) {
            return status == .fullAccess
        } else {
            return status == .authorized
        }
    }
    
    /// Keep AppStorage in sync with the system authorization status.
    @discardableResult
    public func syncAuthorizationStatus() -> Bool {
        let granted = hasCalendarReadAccess
        if isAbleToAccessUserCalendar != granted {
            isAbleToAccessUserCalendar = granted
        }
        return granted
    }
    
    public func accessGranted() {
        isAbleToAccessUserCalendar = true
    }
    
    public func checkCalendarAuthStatus(completion: @escaping (Bool) -> ()) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            isAbleToAccessUserCalendar = false
            requestAccessToCalendar(completion: completion)
        case .authorized:
            accessGranted()
            completion(true)
        case .restricted, .denied:
            isAbleToAccessUserCalendar = false
            completion(false)
        case .fullAccess:
            accessGranted()
            completion(true)
        case .writeOnly:
            // Write-only cannot read events — upgrade to full access.
            requestAccessToCalendar(completion: completion)
        @unknown default:
            isAbleToAccessUserCalendar = false
            completion(false)
        }
    }
    
    public func requestAccessToCalendar(completion: @escaping (Bool) -> ()) {
        let handleResult: (Bool) -> Void = { granted in
            DispatchQueue.main.async {
                if granted {
                    self.accessGranted()
                    self.fetchEvents()
                    completion(true)
                } else {
                    self.isAbleToAccessUserCalendar = false
                    completion(false)
                }
            }
        }
        
        if #available(macOS 14.0, *) {
            eventStore.requestFullAccessToEvents { granted, _ in
                handleResult(granted)
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, _ in
                handleResult(granted)
            }
        }
    }
    
    public func fetchEvents() {
        guard syncAuthorizationStatus() else {
            clearEvents()
            return
        }

        eventCalendars = eventStore.calendars(for: .event).sorted { $0.title < $1.title }

        let oneMonthAgo = Date(timeIntervalSinceNow: -30 * 24 * 3600)
        let oneMonthAfterToday = Date(timeIntervalSinceNow: 30 * 24 * 3600)
        let predicate = eventStore.predicateForEvents(
            withStart: oneMonthAgo,
            end: oneMonthAfterToday,
            calendars: nil
        )
        let matchedEvents = eventStore.events(matching: predicate)
            .filter { isCalendarVisible($0.calendar) }
            .sorted { $0.startDate < $1.startDate }

        events = matchedEvents
        titles = matchedEvents.compactMap(\.title)
        startDates = matchedEvents.map(\.startDate)
        endDates = matchedEvents.map(\.endDate)
        futureEvents = upcomingEvents(from: matchedEvents)
    }

    /// Queries EventKit directly over an arbitrary range, so results are not capped to the
    /// ±30 day window `fetchEvents()` keeps in memory. Hidden calendars are excluded.
    public func events(from start: Date, to end: Date) -> [EKEvent] {
        guard hasCalendarReadAccess, end > start else { return [] }
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        return eventStore.events(matching: predicate)
            .filter { isCalendarVisible($0.calendar) }
            .sorted { $0.startDate < $1.startDate }
    }

    /// Whether events on the given calendar should be shown.
    public func isCalendarVisible(_ calendar: EKCalendar) -> Bool {
        !hiddenCalendarIdentifiers.contains(calendar.calendarIdentifier)
    }

    public func setCalendar(_ calendar: EKCalendar, visible: Bool) {
        var hidden = hiddenCalendarIdentifiers
        if visible {
            hidden.remove(calendar.calendarIdentifier)
        } else {
            hidden.insert(calendar.calendarIdentifier)
        }
        hiddenCalendarIdentifiers = hidden
        fetchEvents()
    }

    private var hiddenCalendarIdentifiers: Set<String> {
        get { Set(hiddenCalendarIdentifiersRaw.split(separator: ",").map(String.init)) }
        set { hiddenCalendarIdentifiersRaw = newValue.joined(separator: ",") }
    }

    /// Creates and saves a new event. Requires calendar write access, which is granted
    /// alongside read access by `requestAccessToCalendar`.
    @discardableResult
    public func createEvent(title: String, start: Date, end: Date, calendar: EKCalendar? = nil) -> Result<Void, EventCreationError> {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return .failure(.emptyTitle) }
        guard end > start else { return .failure(.invalidDateRange) }
        guard hasCalendarReadAccess else { return .failure(.noAccess) }

        let event = EKEvent(eventStore: eventStore)
        event.title = trimmedTitle
        event.startDate = start
        event.endDate = end
        event.calendar = calendar
            ?? eventStore.defaultCalendarForNewEvents
            ?? eventStore.calendars(for: .event).first { $0.allowsContentModifications }

        guard event.calendar != nil else { return .failure(.noWritableCalendar) }

        do {
            try eventStore.save(event, span: .thisEvent)
            fetchEvents()
            return .success(())
        } catch {
            return .failure(.saveFailed(error.localizedDescription))
        }
    }
    
    public func getFutureEvents() -> [EKEvent] {
        upcomingEvents(from: events)
    }

    // MARK: - Reminders

    public var hasReminderReadAccess: Bool {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        if #available(macOS 14.0, *) {
            return status == .fullAccess
        } else {
            return status == .authorized
        }
    }

    public func requestReminderAccess(completion: @escaping (Bool) -> Void = { _ in }) {
        let handleResult: (Bool) -> Void = { granted in
            DispatchQueue.main.async {
                if granted {
                    self.fetchReminders()
                } else {
                    self.reminders = []
                }
                completion(granted)
            }
        }
        if #available(macOS 14.0, *) {
            eventStore.requestFullAccessToReminders { granted, _ in handleResult(granted) }
        } else {
            eventStore.requestAccess(to: .reminder) { granted, _ in handleResult(granted) }
        }
    }

    public func fetchReminders() {
        guard hasReminderReadAccess else {
            reminders = []
            return
        }
        
        reminderCalendars = eventStore.calendars(for: .reminder).sorted { $0.title < $1.title }
        let predicate = eventStore.predicateForReminders(in: reminderCalendars)
        eventStore.fetchReminders(matching: predicate) { [weak self] fetched in
            DispatchQueue.main.async {
                self?.reminders = (fetched ?? []).filter { !$0.isCompleted }
            }
        }
    }

    /// Reminders due on the given calendar day. Reminders without a due date are not day-scoped
    /// and are excluded here.
    public func reminders(on day: Date) -> [EKReminder] {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: day)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else { return [] }
        return reminders.filter { reminder in
            guard let components = reminder.dueDateComponents, let due = calendar.date(from: components) else { return false }
            return due >= dayStart && due < dayEnd
        }
    }

    /// Creates and saves a new reminder due on the given date. A due date is always set so the
    /// reminder is day-scoped, which is what `reminders(on:)` and the day list filter on.
    @discardableResult
    public func createReminder(title: String, dueDate: Date, calendar: EKCalendar? = nil) -> Result<Void, ReminderCreationError> {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return .failure(.emptyTitle) }
        guard hasReminderReadAccess else { return .failure(.noAccess) }

        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = trimmedTitle
        reminder.dueDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: dueDate
        )
        reminder.calendar = calendar
            ?? eventStore.defaultCalendarForNewReminders()
            ?? eventStore.calendars(for: .reminder).first { $0.allowsContentModifications }

        guard reminder.calendar != nil else { return .failure(.noWritableList) }

        do {
            try eventStore.save(reminder, commit: true)
            fetchReminders()
            return .success(())
        } catch {
            return .failure(.saveFailed(error.localizedDescription))
        }
    }

    @discardableResult
    public func setReminderCompleted(_ reminder: EKReminder, completed: Bool) -> Result<Void, EventCreationError> {
        reminder.isCompleted = completed
        do {
            try eventStore.save(reminder, commit: true)
            fetchReminders()
            return .success(())
        } catch {
            return .failure(.saveFailed(error.localizedDescription))
        }
    }
    
    /// Events that occur on the given calendar day (including multi-day events that span it).
    public func events(on day: Date) -> [EKEvent] {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: day)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
            return []
        }
        return events
            .filter { $0.startDate < dayEnd && $0.endDate > dayStart }
            .sorted { $0.startDate < $1.startDate }
    }
    
    /// Distinct calendar colors for events occurring on the given day.
    public func calendarColors(on day: Date) -> [Color] {
        var seen = Set<String>()
        var colors: [Color] = []
        for event in events(on: day) {
            let id = event.calendar.calendarIdentifier
            guard seen.insert(id).inserted else { continue }
            colors.append(event.calendarColor)
        }
        return colors
    }
    
    private func upcomingEvents(from source: [EKEvent]) -> [EKEvent] {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        return source
            .filter { $0.startDate >= startOfToday }
            .sorted { $0.startDate < $1.startDate }
    }
    
    private func clearEvents() {
        events = []
        titles = []
        startDates = []
        endDates = []
        futureEvents = []
    }

}
