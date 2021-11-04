//
//  EventKitManager.swift
//  CalendarQuickView
//
//  Created by David Malicke on 11/1/21.
//

import Foundation
import EventKit

class EventKitManager {
    
    static let shared = EventKitManager()
    private init() { }
    
    let eventStore = EKEventStore()
    
    var calendars: [EKCalendar]?
    
    func checkCalendarAuthStatus(completion: @escaping (Bool) -> ()) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch(status) {
        case EKAuthorizationStatus.notDetermined:
            //first run
            requestAccessToCalendar(completion: completion)
        case EKAuthorizationStatus.authorized:
            completion(true)
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    func requestAccessToCalendar(completion: @escaping (Bool) -> ()) {
        eventStore.requestAccess(to: .event) { accessGranted, error in
            if accessGranted == true {
                DispatchQueue.main.async {
                    self.calendars = self.eventStore.calendars(for: EKEntityType.event)
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
