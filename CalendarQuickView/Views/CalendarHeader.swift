//
//  CalendarHeader.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarHeader: View {
    
    @AppStorage(AppStorageKeys.calendarSize) var calendarSize: CalendarSize = .small
    @Binding var displayDate: Date
    let calendar: Calendar
    let titleFormatter: DateFormatter
    var fontSize: Font = .body
    var buttonSize: CGFloat = 20
    
    init(displayDate: Binding<Date>, calendar: Calendar, titleFormatter: DateFormatter) {
        self._displayDate = displayDate
        self.calendar = calendar
        self.titleFormatter = titleFormatter
        self.fontSize = self.calendarSize == .small ? .title2 : calendarSize == .medium ? .title : .largeTitle
        self.buttonSize = self.calendarSize == .small ? 20 : calendarSize == .medium ? 30 : 40

    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                // MARK: - Month Name "MMM YY"
                Text(titleFormatter.string(from: displayDate))
                    .font(fontSize)
                Spacer()    
                // MARK: - Previous Month Button
                Button(action: {
                    guard let newDate = calendar.date(byAdding: .month, value: -1, to: displayDate) else {
                        return
                    }
                    withAnimation(.easeOut) {
                        displayDate = newDate
                    }
                },
                       label: {
                    Image(systemName: "chevron.left")
                        .frame(width: buttonSize, height: buttonSize)
                })
                    .padding(.horizontal, 5)
                // MARK: - GoTo Current Date Button
                Button(action: {
                    withAnimation(.easeIn) {
                        displayDate = Date()
                    }
                }, label: {
                    Image(systemName: "calendar")
                        .frame(width: buttonSize, height: buttonSize)
                })
                    .padding(.trailing, 5)
                // MARK: - Next Month Button
                Button(action: {
                    guard let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) else {
                        return
                    }
                    withAnimation(.easeIn) {
                        displayDate = newDate
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .frame(width: buttonSize, height: buttonSize)
                })
            }
        }
    }
}
