//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import SwiftUI

struct CalendarDay: View {
    
    @EnvironmentObject private var viewModel: CalendarViewModel
    
    private let date: Date
    private let calendarDayCellSize: CGFloat
    private var displayMonth: Date
    
    init(for date: Date, size: CGFloat, displayMonth: Date) {
        self.calendarDayCellSize = size
        self.date = date
        self.displayMonth = displayMonth
    }
    
    var body: some View {
        let dayColors = viewModel.getDayColors(for: date, in: displayMonth)
        return Text(String(viewModel.calendar.component(.day, from: date)))
            .frame(width: calendarDayCellSize, height: calendarDayCellSize)
            .foregroundColor(dayColors.text)
            .background(dayColors.bgColor)
            .if(viewModel.dayDisplayShape != .none) { textView in
                textView.clipShape(viewModel.dayDisplayShape.shape)
            }
            .padding(.vertical, 4)
    }
}

