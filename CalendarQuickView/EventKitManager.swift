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
    
    let eventStore = EKEventStore()
    
    var calendars: [EKCalendar]?
    
    func checkCalendarAuthStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch(status) {
            
        case EKAuthorizationStatus.notDetermined:
            //first run
            requestAccessToCalendar()
            
        case EKAuthorizationStatus.authorized:
            print("Authorized")
            
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            
            break
            
        @unknown default:
            fatalError()
        }
        
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { accessGranted, error in
            
            if accessGranted == true {
                DispatchQueue.main.async {
                    print("success")
                    self.calendars = self.eventStore.calendars(for: EKEntityType.event)
                    print("\(String(describing: self.calendars?.count))")
                    print(self.calendars![0].title)
                    
                }
            } else {
                DispatchQueue.main.async {
                    print("fail")
                }
            }
        }
    }
}
