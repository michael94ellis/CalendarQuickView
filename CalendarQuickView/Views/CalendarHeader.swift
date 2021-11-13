//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarHeader: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel

    var titleText: some View {
        let titleFontSize: Font = self.viewModel.calendarSize == .small ? .title2 : self.viewModel.calendarSize == .medium ? .title : .largeTitle
        return Text(viewModel.titleDateFormatter.string(from: viewModel.displayDate))
            .foregroundColor(viewModel.titleTextColor)
            .font(titleFontSize)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                titleText
                Spacer()
                // MARK: - Previous Month Button
                CalendarButton(imageName: "chevron.left", buttonSize: viewModel.buttonSize, animation: .easeOut) {
                    viewModel.displayDate.incrementMonths(by: -1)
                }
                .padding(.horizontal, 5)
                .foregroundColor(viewModel.buttonColor)
                // MARK: - GoTo Current Date Button
                CalendarButton(imageName: "calendar", buttonSize: viewModel.buttonSize, animation: .spring()) {
                    viewModel.displayDate = Date()
                }
                .padding(.trailing, 5)
                .foregroundColor(viewModel.buttonColor)
                // MARK: - Next Month Button
                CalendarButton(imageName: "chevron.right", buttonSize: viewModel.buttonSize, animation: .easeIn) {
                    viewModel.displayDate.incrementMonths(by: 1)
                }
                .foregroundColor(viewModel.buttonColor)
            }
        }
    }
}
