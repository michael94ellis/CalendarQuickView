//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import SwiftUI

struct CalendarDay: View {
        
    private let date: Date
    private let fontSize: Font
    private let cellSize: CGFloat
    private let dayShape: DayDisplayShape
    private let dayColors: (text: Color, bgColor: Color)
    
    init(date: Date, fontSize: Font, cellSize: CGFloat, dayShape: DayDisplayShape, month: Date) {
        self.date = date
        self.fontSize = fontSize
        self.cellSize = cellSize
        self.dayShape = dayShape
        if Calendar.current.isDateInToday(self.date) {
            // Current Day
            self.dayColors = (ColorStore.shared.currentMonthText, ColorStore.shared.currentMonthColor)
        } else if Calendar.current.isDate(self.date, equalTo: month, toGranularity: .month) {
            // Day in Current Displayed Month
            self.dayColors = (ColorStore.shared.currentMonthText, ColorStore.shared.currentMonthColor)
        } else {
            // Day is not in Current Displayed Month
            self.dayColors = (ColorStore.shared.otherMonthText, ColorStore.shared.otherMonthColor)
        }
    }
    
    var body: some View {
        return Text(String(Calendar.current.component(.day, from: date)))
            .frame(width: cellSize, height: cellSize)
            .font(fontSize)
            .foregroundColor(self.dayColors.text)
            .if(dayShape != .none) { textView in
                textView.background(self.dayColors.bgColor)
                    .clipShape(dayShape.shape)
            }
            .padding(.vertical, 4)
    }
}

