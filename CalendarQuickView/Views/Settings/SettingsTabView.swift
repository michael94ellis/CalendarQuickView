//
//  SettingsTabView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/1/21.
//

import SwiftUI
import Combine
import ViewModels

struct SettingsTabView: View {

    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var colorStore = ColorStore()
    @StateObject private var eventManager = EventKitManager()
    @State private var selectedSection: Section? = .general

    private enum Section: String, CaseIterable, Identifiable {
        case general
        case colors
        case events
        case calendars
        case search

        var id: Self { self }

        var title: String {
            switch self {
            case .general: return "General"
            case .colors: return "Theme"
            case .events: return "Events"
            case .calendars: return "Calendars"
            case .search: return "Search"
            }
        }

        var icon: String {
            switch self {
            case .general: return "gear"
            case .colors: return "paintpalette"
            case .events: return "calendar.badge.clock"
            case .calendars: return "checklist"
            case .search: return "magnifyingglass"
            }
        }
    }

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                List(Section.allCases, selection: $selectedSection) { section in
                    Label(section.title, systemImage: section.icon)
                }
            }
            .frame(maxWidth: 200)
            Divider()
            detailContent
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(16)
        }
        .navigationSplitViewStyle(.balanced)
        // The General pane's two columns are a fixed 400pt wide, so the detail side needs
        // roughly that plus padding on top of the sidebar.
        .frame(minWidth: 640, minHeight: 480)
        .environmentObject(viewModel)
        .environmentObject(colorStore)
        .environmentObject(eventManager)
    }

    @ViewBuilder
    private var detailContent: some View {
        switch selectedSection {
        case .general:
            GeneralSettings()
        case .colors:
            ColorSettings()
        case .events:
            EventSettings()
        case .calendars:
            CalendarSettings()
        case .search:
            SearchSettings()
        case .none:
            Text("Select a section")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
