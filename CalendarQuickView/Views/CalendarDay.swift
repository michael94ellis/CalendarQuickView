//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import SwiftUI

struct CalendarDay: View {
        
    let date: Date
    let fontSize: Font
    let cellSize: CGFloat
    let dayShape: DayDisplayShape
    let dayColors: CalendarViewModel.CalendarDayCellColors
    
    var body: some View {
        return Text(String(Calendar.current.component(.day, from: date)))
            .frame(width: cellSize, height: cellSize)
            .font(fontSize)
            .foregroundColor(dayColors.text)
            .if(dayShape != .none) { textView in
                textView.background(dayColors.bgColor)
                    .clipShape(dayShape.shape)
            }
            .padding(.vertical, 4)
    }
}

