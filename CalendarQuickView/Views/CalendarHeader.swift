//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI
import ViewModels

/// Displays the displayed Month Name and Year as well as buttons to view next/prev/current month
struct CalendarHeader: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    private var colorStore: ColorStore = .init()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                
                // MARK: - Title (Month/Year)
                Text(self.viewModel.titleDateFormatter.string(from: self.viewModel.displayDate))
                    .foregroundColor(colorStore.accentColor)
                    .font(self.viewModel.calendarTitleSize)
                Spacer()
                
                // MARK: - Previous Month Button
                
                CalendarButton(imageName: "chevron.left",
                               animation: .easeOut,
                               color: colorStore.accentColor,
                               size: self.viewModel.buttonSize) {
                    self.viewModel.displayDate.incrementMonths(by: -1)
                }
                .padding(.horizontal, 5)
                .foregroundColor(colorStore.accentColor)
                
                // MARK: - GoTo Current Date Button
                
                CalendarButton(imageName: "calendar",
                               animation: .spring(),
                               color: colorStore.accentColor,
                               size: self.viewModel.buttonSize) {
                    self.viewModel.resetDate()
                }
                .padding(.trailing, 5)
                .foregroundColor(colorStore.accentColor)
                
                // MARK: - Next Month Button
                
                CalendarButton(imageName: "chevron.right",
                               animation: .easeIn,
                               color: colorStore.accentColor,
                               size: self.viewModel.buttonSize) {
                    self.viewModel.displayDate.incrementMonths(by: 1)
                }
                .foregroundColor(colorStore.accentColor)
            }
        }
    }
}
