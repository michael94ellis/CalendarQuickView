//
//  SettingsTabView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/1/21.
//

import SwiftUI
import Combine

struct SettingsTabView: View {
    
    @State var showMenuButton: Bool = true
    @ObservedObject var viewModel = CalendarViewModel.shared
    
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
                    .tag(Tabs.colors)
                    .environmentObject(viewModel)
                ColorSettings()
                    .tabItem {
                        Label("Colors", systemImage: "star")
                    }
                    .tag(Tabs.colors)
                    .environmentObject(viewModel)
                EventSettings()
                    .tabItem {
                        Label("Events", systemImage: "star")
                    }
                    .tag(Tabs.events)
                    .environmentObject(viewModel)
            }
            Spacer()
        }
        .frame(width: 480)
        Spacer()
    }
}
