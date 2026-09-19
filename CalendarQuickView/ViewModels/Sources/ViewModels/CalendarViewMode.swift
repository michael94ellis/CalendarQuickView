//
//  CalendarViewMode.swift
//  ViewModels
//

public enum CalendarViewMode: String, CaseIterable, Codable, Sendable {
    case month
    case agenda

    public var displayName: String {
        switch self {
        case .month: return "Month"
        case .agenda: return "Agenda"
        }
    }

    /// The icon representing switching TO this mode.
    public var iconName: String {
        switch self {
        case .month: return "calendar"
        case .agenda: return "list.bullet"
        }
    }
}
