//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarHeader: View {
    
<<<<<<< HEAD
    @AppStorage(AppStorageKeys.calendarSize) var calendarSize: CalendarSize = .small
    @Binding var displayDate: Date
    let calendar: Calendar
    let titleFormatter: DateFormatter
    var fontSize: Font = .body
    var buttonSize: CGFloat = 20
    
    init(displayDate: Binding<Date>, calendar: Calendar, titleFormatter: DateFormatter) {
        self._displayDate = displayDate
        self.calendar = calendar
        self.titleFormatter = titleFormatter
        self.fontSize = self.calendarSize == .small ? .title2 : calendarSize == .medium ? .title : .largeTitle
        self.buttonSize = self.calendarSize == .small ? 20 : calendarSize == .medium ? 30 : 40
        
=======
    @ObservedObject var viewModel = CalendarViewModel.shared

    let titleFormatter: DateFormatter
    var fontSize: Font = .body
    
    init(displayDate: Binding<Date>, calendar: Calendar, titleFormatter: DateFormatter) {
        self.titleFormatter = titleFormatter
        self.fontSize = viewModel.calendarSize == .small ? .title2 : viewModel.calendarSize == .medium ? .title : .largeTitle
>>>>>>> origin/resizable-calendar
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                // MARK: - Month Name "MMM YY"
<<<<<<< HEAD
                Text(titleFormatter.string(from: displayDate))
                    .font(fontSize)
                Spacer()
                // MARK: - Previous Month Button
                CalendarButton(imageName: "chevron.left", buttonSize: self.buttonSize, animation: .easeOut) {
                    displayDate.incrementMonths(by: -1)
                }
                .padding(.horizontal, 5)
                // MARK: - GoTo Current Date Button
                
                CalendarButton(imageName: "calendar", buttonSize: self.buttonSize, animation: .spring()) {
                    displayDate = Date()
                }
                .padding(.trailing, 5)
                // MARK: - Next Month Button
                CalendarButton(imageName: "chevron.right", buttonSize: self.buttonSize, animation: .easeIn) {
                    displayDate.incrementMonths(by: 1)
=======
                Text(titleFormatter.string(from: viewModel.displayDate))
                    .font(fontSize)
                Spacer()
                // MARK: - Previous Month Button
                CalendarButton(imageName: "chevron.left", buttonSize: viewModel.buttonSize, animation: .easeOut) {
                    viewModel.displayDate.incrementMonths(by: -1)
                }
                .padding(.horizontal, 5)
                // MARK: - GoTo Current Date Button
                CalendarButton(imageName: "calendar", buttonSize: viewModel.buttonSize, animation: .spring()) {
                    viewModel.displayDate = Date()
                }
                .padding(.trailing, 5)
                // MARK: - Next Month Button
                CalendarButton(imageName: "chevron.right", buttonSize: viewModel.buttonSize, animation: .easeIn) {
                    viewModel.displayDate.incrementMonths(by: 1)
>>>>>>> origin/resizable-calendar
                }
            }
        }
    }
}
