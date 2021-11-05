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
                    CircleView(currentDate: currentDate)
                    DayText(dateString: dateString, dateStringColor: dateStringColor)
                }
                
            }
            
            Spacer()
            
            EllipseView(scheduledEvents: scheduledEvents)
            
            
            Spacer()
        }
        .frame(width: 50, height: 50)
        .border(Color.white)
        .background(Color.gray)
    }
}

struct CircleView: View {
    
    var currentDate: Bool
    
    var body: some View {
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
    }
}

struct DayText: View {
    
    var dateString: String
    var dateStringColor: Color
    
    var body: some View {
        
        Text(dateString)
            .font(.body)
            .foregroundColor(dateStringColor)
            .bold()
        //.shadow(radius: -0.5)
        
        
    }
}

struct EllipseView: View {
    
    var scheduledEvents: Bool
    
    var body: some View {
        
        if scheduledEvents {
            RoundedRectangle(cornerRadius: 2)
                .fill(.red)
                .frame(width: 45, height: 5)
                .opacity(0.45)
            //.padding(2)
        } else {
            RoundedRectangle(cornerRadius: 2)
                .fill(.clear)
                .frame(width: 45, height: 5)
                .opacity(0.45)
            //.padding()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayCell()
    }
}
