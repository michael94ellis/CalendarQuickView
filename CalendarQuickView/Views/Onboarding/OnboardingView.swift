//
//  OnboardingView.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 9/22/26.
//

import SwiftUI
import ViewModels

/// First-run walkthrough: what the app does, the two permissions it needs, and where to find it
/// afterwards. Shown once, from `OnboardingWindow.showIfNeeded(eventManager:)`.
struct OnboardingView: View {

    @ObservedObject var eventManager: EventKitManager
    /// Called when the user reaches the end of the walkthrough.
    var onFinish: () -> Void

    @StateObject private var colorStore = ColorStore()
    @State private var step: Step = .welcome

    enum Step: Int, CaseIterable {
        case welcome
        case permissions
        case ready

        var next: Step { Step(rawValue: rawValue + 1) ?? .ready }
        var previous: Step { Step(rawValue: rawValue - 1) ?? .welcome }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch step {
                case .welcome:
                    OnboardingWelcomePage(accentColor: colorStore.accentColor)
                case .permissions:
                    OnboardingPermissionsPage(eventManager: eventManager, accentColor: colorStore.accentColor)
                case .ready:
                    OnboardingReadyPage(accentColor: colorStore.accentColor)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 32)
            .padding(.top, 32)
            .padding(.bottom, 16)

            Divider()

            footer
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
        }
        .frame(width: 520, height: 560)
        .animation(.easeInOut(duration: 0.2), value: step)
    }

    private var footer: some View {
        HStack(spacing: 12) {
            Button("Back") {
                step = step.previous
            }
            .disabled(step == .welcome)
            // Kept in the layout so the page dots stay centered on the first page.
            .opacity(step == .welcome ? 0 : 1)

            Spacer()

            HStack(spacing: 6) {
                ForEach(Step.allCases, id: \.rawValue) { pageStep in
                    Circle()
                        .fill(pageStep == step ? colorStore.accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 7, height: 7)
                }
            }
            .accessibilityHidden(true)

            Spacer()

            Button(step == .ready ? "Get Started" : "Continue") {
                if step == .ready {
                    onFinish()
                } else {
                    step = step.next
                }
            }
            .keyboardShortcut(.defaultAction)
            .buttonStyle(.borderedProminent)
            .tint(colorStore.accentColor)
        }
    }
}

// MARK: - Welcome

private struct OnboardingWelcomePage: View {

    let accentColor: Color

    private static let features: [OnboardingFeature] = [
        .init(icon: "calendar",
              title: "A calendar in your menu bar",
              detail: "Today's date sits in the menu bar. Click it for the whole month."),
        .init(icon: "calendar.badge.clock",
              title: "Events and reminders inline",
              detail: "Days are dotted in each calendar's color, with that day's agenda below."),
        .init(icon: "plus.circle",
              title: "Quick add",
              detail: "Create an event or reminder in a couple of keystrokes, without opening Calendar."),
        .init(icon: "keyboard",
              title: "A global shortcut",
              detail: "Press ⌃⌥C from any app to toggle the calendar. Rebind it in Settings."),
        .init(icon: "paintpalette",
              title: "Themes and sizes",
              detail: "Choose a color theme, calendar size, and date format to taste."),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingPageHeader(
                icon: "calendar",
                accentColor: accentColor,
                title: "Welcome to Calendar Quick View",
                subtitle: "Your calendar, one click away in the menu bar."
            )

            VStack(alignment: .leading, spacing: 14) {
                ForEach(Self.features) { feature in
                    OnboardingFeatureRow(feature: feature, accentColor: accentColor)
                }
            }

            Spacer(minLength: 0)
        }
    }
}

private struct OnboardingFeature: Identifiable {
    let icon: String
    let title: String
    let detail: String

    var id: String { title }
}

private struct OnboardingFeatureRow: View {

    let feature: OnboardingFeature
    let accentColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: feature.icon)
                .font(.system(size: 16))
                .foregroundColor(accentColor)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .fontWeight(.medium)
                Text(feature.detail)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Permissions

/// Owns the live authorization state, so granting access re-renders this page and not the
/// surrounding walkthrough chrome.
private struct OnboardingPermissionsPage: View {

    @ObservedObject var eventManager: EventKitManager
    let accentColor: Color

    @State private var calendarState: EventAccessState = .notDetermined
    @State private var reminderState: EventAccessState = .notDetermined

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            OnboardingPageHeader(
                icon: "lock.shield",
                accentColor: accentColor,
                title: "Grant access",
                subtitle: "Calendar Quick View reads your calendars on this Mac only. Nothing is sent anywhere."
            )

            OnboardingPermissionRow(
                icon: "calendar",
                title: "Calendars",
                detail: "Shows your events on the month grid and in the day's agenda, and lets you add new ones.",
                state: calendarState,
                accentColor: accentColor,
                privacySettingsAnchor: "Privacy_Calendars"
            ) {
                eventManager.checkCalendarAuthStatus { granted in
                    if granted {
                        eventManager.isEventFeatureEnabled = true
                    }
                    refreshStates()
                }
            }

            OnboardingPermissionRow(
                icon: "checklist",
                title: "Reminders",
                detail: "Shows reminders due on the selected day, and lets you add and complete them.",
                state: reminderState,
                accentColor: accentColor,
                privacySettingsAnchor: "Privacy_Reminders"
            ) {
                eventManager.requestReminderAccess { granted in
                    if granted {
                        eventManager.isRemindersFeatureEnabled = true
                    }
                    refreshStates()
                }
            }

            Text("Both are optional — the calendar itself works without them. You can change either later in Settings ▸ Events and Reminders.")
                .font(.callout)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .onAppear(perform: refreshStates)
        // Granting from System Settings happens outside this app, so re-read on the way back.
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            refreshStates()
        }
    }

    private func refreshStates() {
        calendarState = eventManager.calendarAccessState
        reminderState = eventManager.reminderAccessState
    }
}

private struct OnboardingPermissionRow: View {

    let icon: String
    let title: String
    let detail: String
    let state: EventAccessState
    let accentColor: Color
    /// System Settings pane anchor, used once access is denied and EventKit will not re-prompt.
    let privacySettingsAnchor: String
    let requestAccess: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(accentColor)
                .frame(width: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.medium)
                Text(detail)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if state == .denied {
                    Text("Access was denied. macOS only asks once, so it has to be turned back on in System Settings.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            control
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.08))
        )
    }

    @ViewBuilder
    private var control: some View {
        switch state {
        case .granted:
            Label("Granted", systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
                .fixedSize()
        case .notDetermined:
            Button("Allow", action: requestAccess)
                .fixedSize()
        case .denied:
            Button("Open Settings") {
                guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?\(privacySettingsAnchor)") else { return }
                NSWorkspace.shared.open(url)
            }
            .fixedSize()
        }
    }
}

// MARK: - Ready

private struct OnboardingReadyPage: View {

    let accentColor: Color

    private static let tips: [OnboardingFeature] = [
        .init(icon: "menubar.arrow.up.rectangle",
              title: "Open it",
              detail: "Click today's date in the menu bar, or press ⌃⌥C from anywhere."),
        .init(icon: "gear",
              title: "Change anything",
              detail: "The gear at the bottom-right of the popup opens Settings."),
        .init(icon: "list.bullet",
              title: "Switch views",
              detail: "The button beside it toggles between the month grid and an agenda list."),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingPageHeader(
                icon: "checkmark.circle",
                accentColor: accentColor,
                title: "You're all set",
                subtitle: "Calendar Quick View lives in the menu bar — there's no Dock icon unless you ask for one in Settings."
            )

            VStack(alignment: .leading, spacing: 14) {
                ForEach(Self.tips) { tip in
                    OnboardingFeatureRow(feature: tip, accentColor: accentColor)
                }
            }

            Spacer(minLength: 0)
        }
    }
}

// MARK: - Shared chrome

private struct OnboardingPageHeader: View {

    let icon: String
    let accentColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 38))
                .foregroundColor(accentColor)
                .accessibilityHidden(true)
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            Text(subtitle)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
