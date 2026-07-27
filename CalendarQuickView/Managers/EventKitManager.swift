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

class EventKitManager: ObservableObject {
    
    @AppStorage(AppStorageKeys.calendarAccessGranted) var isAbleToAccessUserCalendar: Bool = false
    @AppStorage(AppStorageKeys.isEventFeatureEnabled) var isEventFeatureEnabled: Bool = false
    @AppStorage(AppStorageKeys.numOfEventsToDisplay) var numOfEventsToDisplay: Double = 4

    @Published private(set) var titles: [String] = []
    @Published private(set) var startDates: [Date] = []
    @Published private(set) var endDates: [Date] = []
    @Published private(set) var events: [EKEvent] = []
    @Published private(set) var futureEvents: [EKEvent] = []
    
    let eventStore = EKEventStore()
    static let shared = EventKitManager()
    private init() { }
    
    private var hasCalendarReadAccess: Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        if #available(macOS 14.0, *) {
            return status == .fullAccess
        } else {
            return status == .authorized
        }
    }
    
    func accessGranted() {
        isAbleToAccessUserCalendar = true
    }
    
    func checkCalendarAuthStatus(completion: @escaping (Bool) -> ()) {
        switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
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
            isAbleToAccessUserCalendar = false
            completion(false)
        @unknown default:
            isAbleToAccessUserCalendar = false
            completion(false)
        }
    }
    
    func requestAccessToCalendar(completion: @escaping (Bool) -> ()) {
        let handleResult: (Bool) -> Void = { granted in
            DispatchQueue.main.async {
                if granted {
                    self.accessGranted()
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
    
    func fetchEvents() {
        guard hasCalendarReadAccess || isAbleToAccessUserCalendar else {
            events = []
            titles = []
            startDates = []
            endDates = []
            futureEvents = []
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
        titles = matchedEvents.map(\.title)
        startDates = matchedEvents.map(\.startDate)
        endDates = matchedEvents.map(\.endDate)
        futureEvents = getFutureEvents()
    }
    
    func getFutureEvents() -> [EKEvent] {
        guard let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else {
            return []
        }
        return events
            .filter { $0.startDate >= midnight }
            .sorted { $0.startDate < $1.startDate }
    }

}
