//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import DesignToken
import SwiftUI

struct CalendarDay: View {
        
    private let date: Date
    private let fontSize: Font
    private let cellSize: CGFloat
    private let displayShape: any Shape
    private let dayColors: (text: Color, bgColor: Color)
    private let isSelected: Bool
    private let isToday: Bool
    private let isSelectable: Bool
    private let onSelect: (() -> Void)?
    
    @ObservedObject private var eventManager = EventKitManager.shared
    
    init(
        date: Date,
        fontSize: Font,
        cellSize: CGFloat,
        dayShape: any Shape,
        month: Date,
        isSelected: Bool = false,
        isSelectable: Bool = false,
        onSelect: (() -> Void)? = nil
    ) {
        self.date = date
        self.fontSize = fontSize
        self.cellSize = cellSize
        self.displayShape = dayShape
        self.isSelected = isSelected
        self.isSelectable = isSelectable
        self.onSelect = onSelect
        
        let isToday = Calendar.current.isDateInToday(date)
        self.isToday = isToday
        
        let isInDisplayedMonth = Calendar.current.isDate(date, equalTo: month, toGranularity: .month)
        let normalText = isInDisplayedMonth
            ? ColorStore.shared.currentMonthText
            : ColorStore.shared.otherMonthText
        let normalBackground = isInDisplayedMonth
            ? ColorStore.shared.currentMonthColor
            : ColorStore.shared.otherMonthColor
        let accent = ColorStore.shared.accentColor
        let contrast = AppColors.contrast.color
        
        if isToday {
            self.dayColors = (contrast, accent)
        } else if isSelected {
            self.dayColors = (normalBackground, normalText)
        } else {
            self.dayColors = (normalText, normalBackground)
        }
    }
    
    private var eventColors: [Color] {
        eventManager.calendarColors(on: date)
    }
    
    private var dotSize: CGFloat { max(cellSize / 8, 3) }
    
    var body: some View {
        Text(String(Calendar.current.component(.day, from: date)))
            .frame(width: cellSize, height: cellSize)
            .font(fontSize)
            .foregroundColor(dayColors.text)
            .modifier(DayShapeModifier(
                displayShape: displayShape,
                background: dayColors.bgColor
            ))
            .if(isSelected && !isToday) { view in
                view.overlay(
                    AnyShape(displayShape)
                        .stroke(ColorStore.shared.accentColor, lineWidth: 1.5)
                )
            }
            .if(!eventColors.isEmpty) { view in
                view.overlay(eventDots)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                guard isSelectable else { return }
                onSelect?()
            }
    }
    
    private var eventDots: some View {
        HStack(spacing: 1) {
            ForEach(Array(eventColors.prefix(3).enumerated()), id: \.offset) { _, color in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 2)
    }
}

private struct DayShapeModifier: ViewModifier {
    let displayShape: any Shape
    let background: Color
    
    func body(content: Content) -> some View {
        content
            .background(background)
            .clipShape(AnyShape(displayShape))
    }
}
