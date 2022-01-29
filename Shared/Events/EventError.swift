//
//  EventError.swift
//  TimeDraw
//
//  Created by Michael Ellis on 1/4/22.
//

import EventKit

/// EventError definition
public enum EventError: Error, LocalizedError {
    case mapFromError(Error)
    case unableToAccessCalendar
    case eventAuthorizationStatus(EKAuthorizationStatus? = nil)
    case invalidEvent

    var localizedDescription: String {
        switch self {
        case .invalidEvent: return "Invalid event"
        case .unableToAccessCalendar: return "Unable to access calendar"
        case let .mapFromError(error): return error.localizedDescription
        case let .eventAuthorizationStatus(status):
            if let status = status {
                return "Failed to authorize event persmissson, status: \(status)"
            } else {
                return "Failed to authorize event persmissson"
            }
        }
    }
}
