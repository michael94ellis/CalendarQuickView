//
//  ContentView.swift
//  CalendarCellTest
//
//  Created by David Malicke on 11/5/21.
//

import SwiftUI

struct CalendarDayCell: View {
    @State var currentDate = true
    @State var scheduledEvents = true
    @State var dateString = "22"
    @State var dateStringColor = Color.white
    
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    if currentDate {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 25, height: 25)
                            .opacity(0.45)
                    } else {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 25, height: 25)
                            .opacity(0.45)
                    }
                    Text(dateString)
                        .font(.body)
                        .foregroundColor(dateStringColor)
                        .bold()
                }
                
            }
            
            Spacer()
            
            if scheduledEvents {
                RoundedRectangle(cornerRadius: 2)
                    .fill(.red)
                    .frame(width: 45, height: 5)
                    .opacity(0.45)
            } else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(.clear)
                    .frame(width: 45, height: 5)
                    .opacity(0.45)

                
            }
            
            
            Spacer()
        }
        .frame(width: 50, height: 50)
        .border(Color.white)
        .background(Color.gray)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayCell()
    }
}
