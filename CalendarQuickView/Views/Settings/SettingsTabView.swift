//
//  SettingsTabView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/1/21.
//

import SwiftUI
import Combine
import ViewModels
import ThemePicker

struct SettingsTabView: View {
    
    @State var showMenuButton: Bool = true
    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var colorStore = ColorStore()
    @StateObject private var eventManager = EventKitManager()
    @StateObject private var launchAtLoginMonitor = LaunchAtLoginMonitor()
    
    private enum Tabs: Hashable {
        case general
        case colors
        case events
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Calendar Quick View Settings")
                    .font(.title)
                    .padding()
                Spacer()
                Button(action: {
                    NSApp.terminate(self)
                }, label: { Text("Quit App") })
                    .padding()
            }
            TabView {
                GeneralSettings()
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
                    .tag(Tabs.general)
                ColorSettings()
                    .tabItem {
                        Label("Theme", systemImage: "paintpalette")
                    }
                    .tag(Tabs.colors)
                EventSettings()
                    .tabItem {
                        Label("Events", systemImage: "star")
                    }
                    .tag(Tabs.events)
            }
            .environmentObject(viewModel)
            .environmentObject(colorStore)
            .environmentObject(eventManager)
            .environmentObject(launchAtLoginMonitor)
            Spacer()
        }
        .frame(width: 480)
        Spacer()
    }
}
