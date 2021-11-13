//
//  CalendarFooter.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct CalendarFooter: View {
    
    let buttonSize: CGFloat
    var settingWindowCallback: () -> () = { }
    
    init(buttonSize: CGFloat, openSettings settingWindowCallback: @escaping () -> ()) {
        self.settingWindowCallback = settingWindowCallback
        self.buttonSize = buttonSize
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            CalendarButton(imageName: "gear", buttonSize: buttonSize, animation: .linear, action: self.settingWindowCallback)
                .foregroundColor(Color.button)
        }
    }
}

