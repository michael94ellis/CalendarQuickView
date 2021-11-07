//
//  CalendarButton.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/6/21.
//
<<<<<<< HEAD

=======
>>>>>>> origin/resizable-calendar
import SwiftUI

struct CalendarButton: View {
    
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
        })
    }
}
<<<<<<< HEAD

=======
>>>>>>> origin/resizable-calendar
