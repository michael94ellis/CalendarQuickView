//
//  QuickAddEventView.swift
//  CalendarQuickView
//

import EventKit
import SwiftUI
import ViewModels

/// A minimal add-event form: title, start, end. No calendar picker, no recurrence,
/// no location — just enough to get an event on the calendar.
///
/// This is hosted in its own window rather than inside the status menu: menus run their own
/// event-tracking run loop, where no view can become first responder, so a text field placed
/// there never receives keystrokes.
struct QuickAddEventView: View {

    @EnvironmentObject private var eventManager: EventKitManager

    let defaultDate: Date
    let onClose: () -> Void

    @State private var title: String = ""
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var errorMessage: String?
    @FocusState private var titleFieldFocused: Bool

    init(defaultDate: Date, onClose: @escaping () -> Void) {
        self.defaultDate = defaultDate
        self.onClose = onClose
        let calendar = Calendar.current
        let start = calendar.date(
            bySettingHour: calendar.component(.hour, from: Date()),
            minute: 0,
            second: 0,
            of: defaultDate
        ) ?? defaultDate
        _startDate = State(initialValue: start)
        _endDate = State(initialValue: start.addingTimeInterval(3600))
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && endDate > startDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)
                .focused($titleFieldFocused)
                .onSubmit(addEvent)
                .onChange(of: title) { _ in errorMessage = nil }

            DatePicker("Starts", selection: $startDate)
                .onChange(of: startDate) { newStart in
                    if endDate <= newStart {
                        endDate = newStart.addingTimeInterval(3600)
                    }
                }
            DatePicker("Ends", selection: $endDate, in: startDate...)

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
                Button("Add", action: addEvent)
                    .keyboardShortcut(.defaultAction)
                    .disabled(!isValid)
            }
        }
        .padding(16)
        .frame(width: 300)
        .onAppear { titleFieldFocused = true }
    }

    private func addEvent() {
        guard isValid else { return }
        switch eventManager.createEvent(title: title, start: startDate, end: endDate) {
        case .success:
            onClose()
        case .failure(let error):
            errorMessage = error.errorDescription
        }
    }
}
