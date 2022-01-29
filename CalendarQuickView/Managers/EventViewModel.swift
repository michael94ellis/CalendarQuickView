//
//  EventViewModel.swift
//  CalendarQuickView
//
//  Created by David Malicke on 11/1/21.
//

import Foundation
import EventKit
import AppKit
import SwiftUI

class EventViewModel: ObservableObject {
    
    @AppStorage(AppStorageKeys.calendarAccessGranted) var isAbleToAccessUserCalendar: Bool = false
    @AppStorage(AppStorageKeys.isEventFeatureEnabled) var isEventFeatureEnabled: Bool = false
    @AppStorage(AppStorageKeys.numOfEventsToDisplay) var numOfEventsToDisplay: Double = 4
    
    private(set) var events: [EKEvent] = []
    
    static let shared = EventViewModel()
    private init() { }
    
    func fetchEvents(on date: Date, completion: @escaping (([EKEvent]) -> ()) ) {
        defer {  }
        self.events = []
        Task {
            let ee = try await EventManager.shared.fetchEvents(for: date, filterCalendarIDs: [])
            DispatchQueue.main.async {
                self.events = ee
                completion(self.events)
            }
        }
    }
}
