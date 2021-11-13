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
    
    static let shared = EventKitManager()
    private init() { }
    
    let eventStore = EKEventStore()
    @AppStorage(AppStorageKeys.calendarAccessGranted) var isAbleToAccessUserCalendar: Bool = false
    @AppStorage(AppStorageKeys.isEventFeatureEnabled) var isEventFeatureEnabled: Bool = true
    @AppStorage(AppStorageKeys.eventDisplayFromDate) var eventDisplayFromDate: EventDisplayDate = .currentDay
    @AppStorage(AppStorageKeys.numOfEventsToDisplay) var numOfEventsToDisplay: Double = 4

    // MARK: - Event Data
    var titles: [String] = []
    var startDates: [Date] = []
    var endDates: [Date] = []
    var events: [EKEvent] = []
    
    func accessGranted() {
        isAbleToAccessUserCalendar = true
    }
    
    func checkCalendarAuthStatus(completion: @escaping (Bool) -> ()) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch(status) {
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
    
    func getEvents() {
        
        for calendar in self.eventStore.calendars(for: EKEntityType.event) {
            self.titles = []
            self.startDates = []
            self.endDates = []
            
            let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
            let oneMonthAfter = Date(timeIntervalSinceNow: +30*24*3600)
            
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
            for event in eventStore.events(matching: predicate) {
                titles.append(event.title)
                startDates.append(event.startDate)
                endDates.append(event.endDate)
                events.append(event)
            }
        }
    }

}
