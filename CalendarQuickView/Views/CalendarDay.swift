//
//  CalendarDay.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/12/21.
//

import SwiftUI
import EventKit

struct CalendarDay: View {
    
    private let calendarDayModel: CalendarDayModel
    @State var showPopOver: Bool = false
    private var eventsThisDay: [EKEvent]
    
    
    init(dayModel: CalendarDayModel) {
        self.calendarDayModel = dayModel
        self.eventsThisDay = EventViewModel.shared.events.filter { Calendar.current.isDate($0.startDate, inSameDayAs: dayModel.date) }
    }
    
    @ViewBuilder
    var popoverView: some View {
        VStack {
            if !self.eventsThisDay.isEmpty {
                EventDayPopUpView(events: eventsThisDay)
            } else {
                Text("No data found")
            }
        }
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
            .if(!self.eventsThisDay.isEmpty) { view in
                view.overlay(Circle().fill(ColorStore.shared.eventTextColor).frame(width: self.calendarDayModel.cellSize / 8, height: self.calendarDayModel.cellSize / 8).position(x: self.calendarDayModel.cellSize / 2, y: self.calendarDayModel.cellSize - (self.calendarDayModel.cellSize / 8)))
                // TODO: Fix the tap issue
                    .onTapGesture {
                        showPopOver.toggle()
                    }
                // 24 30 42
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.showPopOver.toggle()
            }
            .popover(isPresented: self.$showPopOver) {
                self.popoverView
            }
    }
}


