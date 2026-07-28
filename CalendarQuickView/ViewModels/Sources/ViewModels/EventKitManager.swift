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

public final class EventKitManager: ObservableObject {
    
    @AppStorage(AppStorageKeys.calendarAccessGranted) public var isAbleToAccessUserCalendar: Bool = false
    @AppStorage(AppStorageKeys.isEventFeatureEnabled) public var isEventFeatureEnabled: Bool = false

    @Published public private(set) var titles: [String] = []
    @Published public private(set) var startDates: [Date] = []
    @Published public private(set) var endDates: [Date] = []
    @Published public private(set) var events: [EKEvent] = []
    @Published public private(set) var futureEvents: [EKEvent] = []
    
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
        
        let oneMonthAgo = Date(timeIntervalSinceNow: -30 * 24 * 3600)
        let oneMonthAfterToday = Date(timeIntervalSinceNow: 30 * 24 * 3600)
        let predicate = eventStore.predicateForEvents(
            withStart: oneMonthAgo,
            end: oneMonthAfterToday,
            calendars: nil
        )
        let matchedEvents = eventStore.events(matching: predicate)
            .sorted { $0.startDate < $1.startDate }
        
        events = matchedEvents
        titles = matchedEvents.compactMap(\.title)
        startDates = matchedEvents.map(\.startDate)
        endDates = matchedEvents.map(\.endDate)
        futureEvents = upcomingEvents(from: matchedEvents)
    }
    
    public func getFutureEvents() -> [EKEvent] {
        upcomingEvents(from: events)
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
