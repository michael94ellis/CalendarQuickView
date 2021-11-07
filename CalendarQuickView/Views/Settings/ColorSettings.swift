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
                Spacer()
                Text("Background Colors").font(.title2).fontWeight(.bold)
                Spacer()
                Text("Reset All")
                CalendarButton(imageName: "arrow.triangle.2.circlepath", buttonSize: viewModel.buttonSize, animation: .linear, action: {
                    viewModel.currentMonthDaysBGColor = Color.blue
                    viewModel.prevMonthDaysBGColor = Color.darkGray
                    viewModel.nextMonthDaysBGColor = Color.darkGray
                    viewModel.currentDayBGColor = Color.green
                    viewModel.selectedDayBGColor = Color.yellow
                    viewModel.weekDayHeaderBGColor = Color.darkGray
                })
                Spacer()
            }
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
                    ColorPickerWithFrame($viewModel.weekDayHeaderBGColor)
                    ColorPickerWithFrame($viewModel.currentDayBGColor)
                    ColorPickerWithFrame($viewModel.selectedDayBGColor)
                    ColorPickerWithFrame($viewModel.prevMonthDaysBGColor)
                    ColorPickerWithFrame($viewModel.currentMonthDaysBGColor)
                    ColorPickerWithFrame($viewModel.nextMonthDaysBGColor)
                }
            }
            Divider()
            HStack {
                Spacer()
                Text("Text Colors").font(.title2).fontWeight(.bold)
                Spacer()
                Text("Reset All")
                CalendarButton(imageName: "arrow.triangle.2.circlepath", buttonSize: viewModel.buttonSize, animation: .linear, action: {
                    viewModel.currentMonthDaysTextColor = Color.white
                    viewModel.prevMonthDaysTextColor = Color.white
                    viewModel.nextMonthDaysTextColor = Color.white
                    viewModel.currentDayTextColor = Color.black
                    viewModel.selectedDayTextColor = Color.darkGray
                    viewModel.weekDayHeaderTextColor = Color.white
                })
                Spacer()
            }
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
                    ColorPickerWithFrame($viewModel.weekDayHeaderTextColor)
                    ColorPickerWithFrame($viewModel.currentDayTextColor)
                    ColorPickerWithFrame($viewModel.selectedDayTextColor)
                    ColorPickerWithFrame($viewModel.prevMonthDaysTextColor)
                    ColorPickerWithFrame($viewModel.currentMonthDaysTextColor)
                    ColorPickerWithFrame($viewModel.nextMonthDaysTextColor)
                }
            }
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
