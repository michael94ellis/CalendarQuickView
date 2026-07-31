//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import SwiftUI
import ViewModels

struct CalendarDay: View {
        
    private let date: Date
    private let fontSize: Font
    private let cellSize: CGFloat
    private let displayShape: AnyShape
    private let month: Date
    private let isSelected: Bool
    private let isSelectable: Bool
    private let onSelect: (() -> Void)?
    private let eventColors: [Color]?
    
    private var colorStore: ColorStore = .init()
    
    init(
        date: Date,
        fontSize: Font,
        cellSize: CGFloat,
        dayShape: AnyShape,
        month: Date,
        isSelected: Bool = false,
        isSelectable: Bool = false,
        onSelect: (() -> Void)? = nil,
        eventColors: [Color]? = nil
    ) {
        self.date = date
        self.fontSize = fontSize
        self.cellSize = cellSize
        self.displayShape = dayShape
        self.month = month
        self.isSelected = isSelected
        self.isSelectable = isSelectable
        self.onSelect = onSelect
        self.eventColors = eventColors
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var dayColors: (text: Color, bgColor: Color) {
        let isInDisplayedMonth = Calendar.current.isDate(date, equalTo: month, toGranularity: .month)
        let normalText = isInDisplayedMonth
            ? colorStore.currentMonthText
            : colorStore.otherMonthText
        let normalBackground = isInDisplayedMonth
            ? colorStore.currentMonthColor
            : colorStore.otherMonthColor
        if isSelected {
            return (normalBackground, normalText)
        } else {
            return (normalText, normalBackground)
        }
    }
    
    private var dotSize: CGFloat { max(cellSize / 8, 3) }
    
    @ViewBuilder
    var mainBodyContainer: some View {
        if isSelected || isToday {
            mainBodyText
                .overlay(
                    displayShape
                        .stroke(colorStore.accentColor, lineWidth: 1.5)
                )
        } else {
            mainBodyText    
                .contentShape(Rectangle())
        }
    }
    
    var mainBodyText: some View {
        Text(String(Calendar.current.component(.day, from: date)))
            .frame(width: cellSize, height: cellSize)
            .font(fontSize)
            .foregroundColor(dayColors.text)
            .modifier(DayShapeModifier(
                displayShape: displayShape,
                background: dayColors.bgColor
            ))
    }
    
    var body: some View {
        Group {
            if let eventColors {
                mainBodyContainer
                    .overlay(eventDots(eventColors))
            } else {
                mainBodyContainer
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard isSelectable else { return }
            onSelect?()
        }
    }
    
    private func eventDots(_ eventColors: [Color]) -> some View {
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
    let displayShape: AnyShape
    let background: Color
    
    func body(content: Content) -> some View {
        content
            .background(background)
            .clipShape(displayShape)
    }
}
