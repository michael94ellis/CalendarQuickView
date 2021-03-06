//
//  CalendarFooter.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct CalendarFooter: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    
    var settingWindowCallback: () -> () = { }
    
    init(openSettings settingWindowCallback: @escaping () -> ()) {
        self.settingWindowCallback = settingWindowCallback
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            CalendarButton(imageName: "gear", animation: .linear, color: ColorStore.shared.buttonColor, size: viewModel.buttonSize, action: self.settingWindowCallback)
                .foregroundColor(ColorStore.shared.buttonColor)
        }
    }
}

