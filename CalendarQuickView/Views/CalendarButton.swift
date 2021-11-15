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
    let animation: Animation
    let action: () -> ()
    
    var buttonImage: some View {
        let buttonSize: CGFloat = viewModel.calendarSize == .small ? 20 : viewModel.calendarSize == .medium ? 30 : 40
        return Image(systemName: imageName)
            .frame(width: buttonSize, height: buttonSize)
            .foregroundColor(viewModel.buttonColor)
    }
    
    var body: some View {
        Button(action: {
            withAnimation(animation) {
                action()
            }
        }, label: {
            buttonImage
        })
    }
}
