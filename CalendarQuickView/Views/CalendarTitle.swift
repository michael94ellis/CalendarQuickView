//
//  CalendarTitle.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/2/21.
//

import SwiftUI

struct CalendarTitle: View {
    
    @Binding var displayDate: Date
    let calendar: Calendar
    let titleFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                // MARK: - Month Name "MMM"
                Text(titleFormatter.string(from: displayDate))
                    .font(.title)
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
                    Label(title: { Text("Previous") },
                          icon: { Image(systemName: "chevron.left") })
                        .labelStyle(IconOnlyLabelStyle())
                        .frame(maxHeight: .infinity)
                })
                    .padding(.horizontal, 5)
                // MARK: - Next Month Button
                Button(action: {
                    guard let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) else {
                        return
                    }
                    withAnimation(.easeIn) {
                        displayDate = newDate
                    }
                }, label: {
                    Label(title: { Text("Next") },
                          icon: { Image(systemName: "chevron.right") })
                        .labelStyle(IconOnlyLabelStyle())
                        .frame(maxHeight: .infinity)
                })        }
        }
    }
}
