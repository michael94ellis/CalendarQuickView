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
    
    private enum Tabs: Hashable {
        case general
        case colors
        case events
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Calendar Quick View Settings")
                .font(.title)
                .padding()
            TabView {
                GeneralSettings()
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
                    .tag(Tabs.colors)
                ColorSettings()
                    .tabItem {
                        Label("Colors", systemImage: "star")
                    }
                    .tag(Tabs.colors)
                EventSettings()
                    .tabItem {
                        Label("Events", systemImage: "star")
                    }
                    .tag(Tabs.events)
            }
            Spacer()
        }
        .frame(width: 480)
        Spacer()
    }
}
