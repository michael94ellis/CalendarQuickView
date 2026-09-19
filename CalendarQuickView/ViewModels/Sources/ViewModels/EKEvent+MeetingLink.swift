//
//  EKEvent+MeetingLink.swift
//  ViewModels
//

import EventKit
import Foundation

public extension EKEvent {
    /// Best-guess video call link for this event, checked in the fields conferencing
    /// integrations most commonly place a URL in: the event's own `url`, then `location`,
    /// then `notes`.
    var meetingURL: URL? {
        if let url, EKEvent.looksLikeMeetingLink(url.absoluteString) {
            return url
        }
        for field in [location, notes] {
            guard let field, let found = EKEvent.firstMeetingLink(in: field) else { continue }
            return found
        }
        return nil
    }

    private static let meetingHostFragments = [
        "zoom.us", "meet.google.com", "teams.microsoft.com", "webex.com",
        "whereby.com", "meet.jit.si", "gotomeeting.com", "bluejeans.com",
        "ringcentral.com", "chime.aws"
    ]

    private static func looksLikeMeetingLink(_ string: String) -> Bool {
        let lowered = string.lowercased()
        return meetingHostFragments.contains { lowered.contains($0) }
    }

    private static func firstMeetingLink(in text: String) -> URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        let range = NSRange(text.startIndex..., in: text)
        for match in detector.matches(in: text, range: range) {
            guard let url = match.url, looksLikeMeetingLink(url.absoluteString) else { continue }
            return url
        }
        return nil
    }
}
