//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarHeader: View {
    
    /// Because this view allows the user to change the display it must have a reference to the view model(tightly coupled)
    @EnvironmentObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                
                // MARK: - Title (Month/Year)
                Text(viewModel.titleDateFormatter.string(from: viewModel.displayDate))
                    .foregroundColor(viewModel.titleTextColor)
                    .font(self.viewModel.calendarSize == .small ? .title2 : self.viewModel.calendarSize == .medium ? .title : .largeTitle)
                Spacer()
                
                // MARK: - Previous Month Button
                
                CalendarButton(imageName: "chevron.left", animation: .easeOut, color: viewModel.buttonColor, size: viewModel.buttonSize) {
                    viewModel.displayDate.incrementMonths(by: -1)
                }
                .padding(.horizontal, 5)
                .foregroundColor(viewModel.buttonColor)
                
                // MARK: - GoTo Current Date Button
                
                CalendarButton(imageName: "calendar", animation: .spring(), color: viewModel.buttonColor, size: viewModel.buttonSize) {
                    viewModel.displayDate = Date()
                }
                .padding(.trailing, 5)
                .foregroundColor(viewModel.buttonColor)
                
                // MARK: - Next Month Button
                
                CalendarButton(imageName: "chevron.right", animation: .easeIn, color: viewModel.buttonColor, size: viewModel.buttonSize) {
                    viewModel.displayDate.incrementMonths(by: 1)
                }
                .foregroundColor(viewModel.buttonColor)
            }
        }
    }
}
