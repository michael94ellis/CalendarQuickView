//
//  ColorSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct ColorSettings: View {
    
    @ObservedObject var viewModel: CalendarViewModel = CalendarViewModel.shared
    
    func ColorLabel(_ color: Color, _ text: String) -> some View {
        HStack {
            Text(text).frame(height: 25)
            Rectangle().background(color).frame(width: 25, height: 25)
        }
    }
    
    var ColorLabels: some View {
        VStack(alignment: .leading) {
            ColorLabel(Color.text, "Text")
            ColorLabel(Color.button, "Buttons")
            ColorLabel(Color.primaryBackground, "Primary")
            ColorLabel(Color.secondaryBackground, "Secondary")
        }
    }
    
    var ColorPickers: some View {
        VStack(alignment: .leading) {
            ColorLabel(Color.text, "Text")
            ColorLabel(Color.button, "Buttons")
            ColorLabel(Color.primaryBackground, "Primary")
            ColorLabel(Color.secondaryBackground, "Secondary")
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Colors").font(.title2).fontWeight(.bold)
                Spacer()
                Text("Reset All")
                CalendarButton(imageName: "arrow.triangle.2.circlepath", buttonSize: viewModel.buttonSize, animation: .linear, action: {
                    Color.text = Color(NSColor.labelColor)
                    Color.button = Color(NSColor.labelColor)
                    Color.primaryBackground = Color(NSColor.systemBlue)
                    Color.secondaryBackground = Color(NSColor.systemIndigo).opacity(0.4)
                })
            }
            Divider()
            HStack {
                ColorLabels
                
            }
            Spacer()
        }
        .frame(width: 300)
        .padding(.vertical, 20)
    }
}
