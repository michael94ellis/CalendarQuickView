//
//  ColorSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct ColorSettings: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared
    @State var toggles: [Bool] = []
    
    func TextWithFrame(_ text: String) -> some View {
        Text(text).frame(height: 25)
    }
    
    func ColorPickerWithFrame(_ colorBinding: Binding<Color>) -> some View {
        HStack {
            ColorPicker("", selection: colorBinding).frame(height: 25)
            Button("None") {
                colorBinding.wrappedValue = .clear
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Reset All")
                CalendarButton(imageName: "arrow.triangle.2.circlepath", buttonSize: viewModel.buttonSize, animation: .linear, action: {
                    viewModel.currentMonthDaysColor = Color.blue
                    viewModel.prevMonthDaysColor = Color.lightGray
                    viewModel.nextMonthDaysColor = Color.lightGray
                    viewModel.currentDayColor = Color.green
                    viewModel.selectedDayColor = Color.yellow
                    viewModel.weekDayHeaderColor = Color.darkGray
                })
            }
            Text("Customize Your Colors").font(.title2).fontWeight(.bold)
            HStack {
                // Labels
                VStack(alignment: .leading) {
                    TextWithFrame("Weekday Header Row")
                    TextWithFrame("Current")
                    TextWithFrame("Selected")
                    TextWithFrame("Previous Month")
                    TextWithFrame("Current Month")
                    TextWithFrame("Next Month")
                }
                // Color Pickers
                VStack(alignment: .trailing) {
                    ColorPickerWithFrame($viewModel.weekDayHeaderColor)
                    ColorPickerWithFrame($viewModel.currentDayColor)
                    ColorPickerWithFrame($viewModel.selectedDayColor)
                    ColorPickerWithFrame($viewModel.prevMonthDaysColor)
                    ColorPickerWithFrame($viewModel.currentMonthDaysColor)
                    ColorPickerWithFrame($viewModel.nextMonthDaysColor)
                }
            }
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
