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

    private(set) var titles: [String] = []
    private(set) var startDates: [Date] = []
    private(set) var endDates: [Date] = []
    private(set) var events: [EKEvent] = []
    private(set) var futureEvents: [EKEvent] = []
    
    let eventStore = EKEventStore()
    static let shared = EventKitManager()
    private init() { }
    
    func accessGranted() {
        isAbleToAccessUserCalendar = true
    }
    
    func checkCalendarAuthStatus(completion: @escaping (Bool) -> ()) {
        switch(EKEventStore.authorizationStatus(for: EKEntityType.event)) {
        case EKAuthorizationStatus.notDetermined:
            isAbleToAccessUserCalendar = false
            requestAccessToCalendar(completion: completion)
        case EKAuthorizationStatus.authorized:
            accessGranted()
            completion(isAbleToAccessUserCalendar)
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            isAbleToAccessUserCalendar = false
            completion(isAbleToAccessUserCalendar)
        @unknown default:
            isAbleToAccessUserCalendar = false
            completion(isAbleToAccessUserCalendar)
        }
    }
    
    func requestAccessToCalendar(completion: @escaping (Bool) -> ()) {
        eventStore.requestAccess(to: .event) { accessGranted, error in
            if accessGranted == true {
                DispatchQueue.main.async {
                    self.accessGranted()
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    self.isAbleToAccessUserCalendar = false
                    completion(false)
                }
            }
        }
    }
    
    func fetchEvents() {
        defer { print(events) }
        self.events = []
        self.titles = []
        self.startDates = []
        self.endDates = []
        for calendar in self.eventStore.calendars(for: EKEntityType.event) {
            
            let oneMonthAgo = Date(timeIntervalSinceNow: -30 * 24 * 3600)
            let oneMonthAfterToday = Date(timeIntervalSinceNow: +30 * 24 * 3600)
            
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfterToday, calendars: [calendar])
            for event in eventStore.events(matching: predicate) {
                titles.append(event.title)
                startDates.append(event.startDate)
                endDates.append(event.endDate)
                events.append(event)
                if events.count >= Int(self.numOfEventsToDisplay) {
                    return
                }
            }
        }
        self.futureEvents = self.getFutureEvents()
    }
    
    func getFutureEvents() -> [EKEvent] {
        guard let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else {
            print("Error: No Midnight Date can be made")
            return []
        }
        let futureEvents = self.events.filter { $0.startDate > midnight }
        return futureEvents
    }
    
    func getEventDetails(eventDate : Date) -> [EKEvent]{
        return events.filter { $0.startDate == eventDate}
    }

}
