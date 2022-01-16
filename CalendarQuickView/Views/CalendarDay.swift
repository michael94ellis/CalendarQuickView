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
    private var showEventOverlay: Bool = false
    
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
        self.showEventOverlay = !EventKitManager.shared.startDates.compactMap {
            Calendar.current.isDate($0, inSameDayAs: self.date)
        }.allSatisfy { $0 == false }
    }
    
    var body: some View {
        Text(String(Calendar.current.component(.day, from: date)))
            .frame(width: cellSize, height: cellSize)
            .font(fontSize)
            .foregroundColor(self.dayColors.text)
            .if(dayShape != .none) { textView in
                textView.background(self.dayColors.bgColor)
                    .clipShape(dayShape.shape)
            }
            .if(self.showEventOverlay) { view in
                view.overlay(Circle().fill(ColorStore.shared.eventTextColor).frame(width: cellSize / 8, height: cellSize / 8).position(x: cellSize / 2, y: cellSize - (cellSize / 8)))
                // 24 30 42
            }
    }
}

