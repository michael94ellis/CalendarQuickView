//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import SwiftUI

struct CalendarDay: View {
    
//    private let date: Date
//    private let fontSize: Font
//    private let cellSize: CGFloat
//    private let dayShape: DayDisplayShape
//    private let dayColors: (text: Color, bgColor: Color)
//    private var showEventOverlay: Bool = false
    private let calendarDayModel: CalendarDayModel
    @State var showPopOver: Bool = false
    
    
    init(dayModel : CalendarDayModel) {
        self.calendarDayModel = dayModel
    }
    
    var body: some View {
        
        Text(String(Calendar.current.component(.day, from: self.calendarDayModel.date)))
            .frame(width: self.calendarDayModel.cellSize, height: self.calendarDayModel.cellSize)
            .font(self.calendarDayModel.fontSize)
            .foregroundColor(self.calendarDayModel.dayColors.text)
            .if(self.calendarDayModel.dayShape != .none) { textView in
                textView.background(self.calendarDayModel.dayColors.bgColor)
                    .clipShape(self.calendarDayModel.dayShape.shape)
            }
            .if(self.calendarDayModel.isAnEvent) { view in
                view.overlay(Circle().fill(ColorStore.shared.eventTextColor).frame(width: self.calendarDayModel.cellSize / 8, height: self.calendarDayModel.cellSize / 8).position(x: self.calendarDayModel.cellSize / 2, y: self.calendarDayModel.cellSize - (self.calendarDayModel.cellSize / 8)))
                // TODO: Fix the tap issue
                    .onTapGesture {
                        showPopOver.toggle()
                    }
                
                // 24 30 42
            }
            .popover(isPresented: $showPopOver, content: {
                if self.calendarDayModel.isAnEvent{
                    if let event  = self.calendarDayModel.eventDetails.first{
                        EventDayPopUpView(event: event)
                    } else {
                         Text("No data found")
                    }
                    
                
                }
                
            })
        
        
        
        
        
    }
}


