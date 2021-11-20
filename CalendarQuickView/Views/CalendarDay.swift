//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import SwiftUI

struct CalendarDay: View {
    
    @EnvironmentObject private var viewModel: CalendarViewModel
    
    let date: Date
    let calendarDayCellSize: CGFloat
    let dayColors: CalendarViewModel.CalendarDayCellColors
    let dayShape: AnyShape
    
    var body: some View {
        let fontSize: Font = self.viewModel.calendarSize == .small ? .body : self.viewModel.calendarSize == .medium ? .title3 : .title2
        return Text(String(viewModel.calendar.component(.day, from: date)))
            .frame(width: calendarDayCellSize, height: calendarDayCellSize)
            .font(fontSize)
            .foregroundColor(dayColors.text)
            .if(viewModel.dayDisplayShape != .none) { textView in
                textView.background(dayColors.bgColor)
                    .clipShape(dayShape)
            }
            .padding(.vertical, 4)
    }
}

