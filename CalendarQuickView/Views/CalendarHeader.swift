//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

/// Displays the displayed Month Name and Year as well as buttons to view next/prev/current month
struct CalendarHeader: View {
    
    /// Because this view allows the user to change the display it must have a reference to the view model(tightly coupled)
    @EnvironmentObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                
                // MARK: - Title (Month/Year)
                Text(self.viewModel.titleDateFormatter.string(from: self.viewModel.displayDate))
                    .foregroundColor(ColorStore.shared.titleTextColor)
                    .font(self.viewModel.calendarTitleSize)
                Spacer()
                
                // MARK: - Previous Month Button
                
                CalendarButton(imageName: "chevron.left", animation: .easeOut, color: ColorStore.shared.buttonColor, size: self.viewModel.buttonSize) {
                    self.viewModel.displayDate.incrementMonths(by: -1)
                }
                .padding(.horizontal, 5)
                .foregroundColor(ColorStore.shared.buttonColor)
                
                // MARK: - GoTo Current Date Button
                
                CalendarButton(imageName: "calendar", animation: .spring(), color: ColorStore.shared.buttonColor, size: self.viewModel.buttonSize) {
                    self.viewModel.displayDate = Date()
                }
                .padding(.trailing, 5)
                .foregroundColor(ColorStore.shared.buttonColor)
                
                // MARK: - Next Month Button
                
                CalendarButton(imageName: "chevron.right", animation: .easeIn, color: ColorStore.shared.buttonColor, size: self.viewModel.buttonSize) {
                    self.viewModel.displayDate.incrementMonths(by: 1)
                }
                .foregroundColor(ColorStore.shared.buttonColor)
            }
        }
    }
}
