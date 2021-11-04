//
//  EventKitManager.swift
//  CalendarQuickView
//
//  Created by David Malicke on 11/1/21.
//

import Foundation
import EventKit

class EventKitManager: ObservableObject {
    
    static let shared = EventKitManager()
    private init() {
        checkCalendarAuthStatus(completion: { _ in })
    }
    
    let eventStore = EKEventStore()
    @Published var isAbleToAccessUserCalendar: Bool = false
    var calendars: [EKCalendar]?
    
    // MARK: - Event Data
    var titles: [String] = []
    var startDates: [Date] = []
    var endDates: [Date] = []
    
    func checkCalendarAuthStatus(completion: @escaping (Bool) -> ()) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch(status) {
        case EKAuthorizationStatus.notDetermined:
            isAbleToAccessUserCalendar = false
            requestAccessToCalendar(completion: completion)
        case EKAuthorizationStatus.authorized:
            isAbleToAccessUserCalendar = true
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
                    self.calendars = self.eventStore.calendars(for: EKEntityType.event)
                    self.isAbleToAccessUserCalendar = true
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
        guard let calendars = calendars else {
            print("Error: No calendars to get events from(\(Self.self).calenders is nil)")
            return
        }
        for calendar in calendars {
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
            }
        }
    }
}
