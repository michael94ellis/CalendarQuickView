//
//  LaunchAtLoginMonitor.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import Combine
import SwiftUI
import LaunchAtLogin

/// A simple object to listen for changes in the user's preference to enable the LaunchAtLogin third party Library feature
final class LaunchAtLoginMonitor: ObservableObject {
    /// This is what we are accessing and listening to
    @Published public private(set) var isLaunchAtLoginEnabled = LaunchAtLogin.isEnabled
    private var cancellables = Set<AnyCancellable>()
    /// Only one of this object will ever be needed at a time
    public static let shared = LaunchAtLoginMonitor()
    
    // Binding Management
    private init() { bind() }
    deinit { cancellables.forEach { $0.cancel() } }
    /// Creates a listener to the isEnabled property of the external dependency
    private func bind() {
        LaunchAtLogin
            .publisher
            .assign(to: \.isLaunchAtLoginEnabled, on: self)
            .store(in: &cancellables)
    }
}
/// An empty LaunchAtLogin Toggle Button
public struct LaunchAtLoginMonitorToggle: View {
    public var body: some View {
        LaunchAtLogin.Toggle("")
    }
}
