//
//  QuickAddReminderView.swift
//  CalendarQuickView
//

import EventKit
import SwiftUI
import ViewModels

/// A minimal add-reminder form: title and due date. No list picker, no priority, no notes —
/// the counterpart to `QuickAddEventView`.
///
/// Like the event form, this is hosted in its own window rather than inside the status menu:
/// menus run their own event-tracking run loop, where no view can become first responder, so a
/// text field placed there never receives keystrokes.
struct QuickAddReminderView: View {

    @EnvironmentObject private var eventManager: EventKitManager

    let defaultDate: Date
    let onClose: () -> Void

    @State private var title: String = ""
    @State private var dueDate: Date
    @State private var errorMessage: String?
    @FocusState private var titleFieldFocused: Bool

    init(defaultDate: Date, onClose: @escaping () -> Void) {
        self.defaultDate = defaultDate
        self.onClose = onClose
        let calendar = Calendar.current
        let due = calendar.date(
            bySettingHour: calendar.component(.hour, from: Date()),
            minute: 0,
            second: 0,
            of: defaultDate
        ) ?? defaultDate
        _dueDate = State(initialValue: due)
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)
                .focused($titleFieldFocused)
                .onSubmit(addReminder)
                .onChange(of: title) { _ in errorMessage = nil }

            DatePicker("Due", selection: $dueDate)

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack {
                Spacer()
                Button("Cancel", action: onClose)
                    .keyboardShortcut(.cancelAction)
                Button("Add", action: addReminder)
                    .keyboardShortcut(.defaultAction)
                    .disabled(!isValid)
            }
        }
        .padding(16)
        .frame(width: 300)
        .onAppear { titleFieldFocused = true }
    }

    private func addReminder() {
        guard isValid else { return }
        switch eventManager.createReminder(title: title, dueDate: dueDate) {
        case .success:
            onClose()
        case .failure(let error):
            errorMessage = error.errorDescription
        }
    }
}
