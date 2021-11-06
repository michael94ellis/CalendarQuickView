//
//  CalendarFooter.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct CalendarFooter: View {
    
    @AppStorage(AppStorageKeys.calendarSize) var calendarSize: CalendarSize = .small
    var buttonSize: CGFloat = 20
    
    var settingWindowCallback: () -> () = { }
    
    init(openSettings settingWindowCallback: @escaping () -> ()) {
        self.buttonSize = self.calendarSize == .small ? 20 : calendarSize == .medium ? 30 : 40
        self.settingWindowCallback = settingWindowCallback
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: { }, label: { Image(systemName: "plus")
                    .frame(width: buttonSize, height: buttonSize)
            })
            Spacer()
            CalendarButton(imageName: "gear", buttonSize: self.buttonSize, animation: .linear, action: self.settingWindowCallback)
        }
    }
}

