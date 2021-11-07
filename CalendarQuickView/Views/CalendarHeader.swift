//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarHeader: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared

    let titleFormatter: DateFormatter
    var fontSize: Font = .body
    
    init(displayDate: Binding<Date>, calendar: Calendar, titleFormatter: DateFormatter) {
        self.titleFormatter = titleFormatter
        self.fontSize = viewModel.calendarSize == .small ? .title2 : viewModel.calendarSize == .medium ? .title : .largeTitle
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                // MARK: - Month Name "MMM YY"
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
                }
            }
        }
    }
}
