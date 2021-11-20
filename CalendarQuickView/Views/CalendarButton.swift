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
    let color: Color
    let size: CGFloat
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            withAnimation(animation) {
                action()
            }
        }, label: {
            Image(systemName: imageName)
                .frame(width: size, height: size)
                .foregroundColor(color)
        })
    }
}
