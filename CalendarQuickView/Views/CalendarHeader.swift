//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarHeader: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                // MARK: - Month Name "MMM YY"
                Text(viewModel.titleDateFormatter.string(from: viewModel.displayDate))
                    .foregroundColor(Color.text)
                    .font(viewModel.titleFontSize)
                Spacer()
                // MARK: - Previous Month Button
                CalendarButton(imageName: "chevron.left", buttonSize: viewModel.buttonSize, animation: .easeOut) {
                    viewModel.displayDate.incrementMonths(by: -1)
                }
                .padding(.horizontal, 5)
                .foregroundColor(Color.button)
                // MARK: - GoTo Current Date Button
                CalendarButton(imageName: "calendar", buttonSize: viewModel.buttonSize, animation: .spring()) {
                    viewModel.displayDate = Date()
                }
                .padding(.trailing, 5)
                .foregroundColor(Color.button)
                // MARK: - Next Month Button
                CalendarButton(imageName: "chevron.right", buttonSize: viewModel.buttonSize, animation: .easeIn) {
                    viewModel.displayDate.incrementMonths(by: 1)
                }
                .foregroundColor(Color.button)
            }
        }
    }
}
