//
//  CalendarFooter.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct CalendarFooter: View {
    
<<<<<<< HEAD
    @AppStorage(AppStorageKeys.calendarSize) var calendarSize: CalendarSize = .small
    var buttonSize: CGFloat = 20
=======
    @ObservedObject var viewModel = CalendarViewModel.shared
>>>>>>> origin/resizable-calendar
    
    var settingWindowCallback: () -> () = { }
    
    init(openSettings settingWindowCallback: @escaping () -> ()) {
<<<<<<< HEAD
        self.buttonSize = self.calendarSize == .small ? 20 : calendarSize == .medium ? 30 : 40
=======
>>>>>>> origin/resizable-calendar
        self.settingWindowCallback = settingWindowCallback
    }
    
    var body: some View {
        HStack(spacing: 0) {
<<<<<<< HEAD
            Button(action: { }, label: { Image(systemName: "plus")
                    .frame(width: buttonSize, height: buttonSize)
            })
            Spacer()
            CalendarButton(imageName: "gear", buttonSize: self.buttonSize, animation: .linear, action: self.settingWindowCallback)
=======
            Spacer()
            CalendarButton(imageName: "gear", buttonSize: viewModel.buttonSize, animation: .linear, action: self.settingWindowCallback)
>>>>>>> origin/resizable-calendar
        }
    }
}

