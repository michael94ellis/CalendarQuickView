//
//  CalendarFooter.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct CalendarFooter: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared
    
    var settingWindowCallback: () -> () = { }
    
    init(openSettings settingWindowCallback: @escaping () -> ()) {
        self.settingWindowCallback = settingWindowCallback
    }
    
    var body: some View {
        HStack(spacing: 0) {
            CalendarButton(imageName: "plus", buttonSize: viewModel.buttonSize, animation: .linear, action: { })
            Spacer()
            CalendarButton(imageName: "gear", buttonSize: viewModel.buttonSize, animation: .linear, action: self.settingWindowCallback)
        }
    }
}

