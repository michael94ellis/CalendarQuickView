//
//  CalendarFooter.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI
import ViewModels

struct CalendarFooter: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    private var colorStore: ColorStore = .init()
    
    var settingWindowCallback: () -> () = { }
    
    init(openSettings settingWindowCallback: @escaping () -> ()) {
        self.settingWindowCallback = settingWindowCallback
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            CalendarButton(imageName: "gear", animation: .linear, color: colorStore.accentColor, size: viewModel.buttonSize, action: self.settingWindowCallback)
                .foregroundColor(colorStore.accentColor)
        }
    }
}
