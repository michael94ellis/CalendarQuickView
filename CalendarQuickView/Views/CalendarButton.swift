//
//  CalendarButton.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//

import SwiftUI

struct CalendarButton: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    
    let imageName: String
    let buttonSize: CGFloat
    let animation: Animation
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            withAnimation(animation) {
                action()
            }
        }, label: {
            Image(systemName: imageName)
                .frame(width: buttonSize, height: buttonSize)
                .foregroundColor(viewModel.buttonColor)
        })
    }
}
