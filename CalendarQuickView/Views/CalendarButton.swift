//
//  CalendarButton.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//

import SwiftUI

struct CalendarButton: View {
        
    let imageName: String
    let animation: Animation
    let font: Font
    let color: Color
    let size: CGFloat
    let action: () -> ()
    
    init(imageName: String,
         animation: Animation,
         font: Font = .body,
         color: Color,
         size: CGFloat,
         action: @escaping () -> Void) {
        self.imageName = imageName
        self.animation = animation
        self.font = font
        self.color = color
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            withAnimation(animation) {
                action()
            }
        }, label: {
            Image(systemName: imageName)
                .frame(width: size, height: size)
                .foregroundColor(color)
                .font(font)
        })
    }
}
