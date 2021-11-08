//
//  ColorSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct ColorSettings: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared
    
    func TextWithFrame(_ text: String) -> some View {
        Text(text).frame(height: 25)
    }
    
    func ColorPickerWithFrame(_ colorBinding: Binding<Color>) -> some View {
        HStack {
            ColorPicker("", selection: colorBinding).frame(height: 25)
            Button("None") {
                colorBinding.wrappedValue = .systemBackground
            }
        }
    }
    
    var Labels: some View {
        VStack(alignment: .leading) {
            TextWithFrame("Weekday Header Row")
            TextWithFrame("Today")
            TextWithFrame("Selected")
            TextWithFrame("Previous Month")
            TextWithFrame("Current Month")
            TextWithFrame("Next Month")
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
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
            }
            ColorThemes()
            HStack {
                Labels
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
                Text("Text Colors").font(.title2).fontWeight(.bold)
                Spacer()
                Text("Reset All")
                CalendarButton(imageName: "arrow.triangle.2.circlepath", buttonSize: viewModel.buttonSize, animation: .linear, action: {
                    viewModel.currentMonthDaysTextColor = Color.white
                    viewModel.prevMonthDaysTextColor = Color.white
                    viewModel.nextMonthDaysTextColor = Color.white
                    viewModel.currentDayTextColor = Color.black
                    viewModel.selectedDayTextColor = Color.darkGray
                    viewModel.weekdayHeaderTextColor = Color.white
                })
            }
            HStack {
                VStack {
                    TextWithFrame("Title, Events, Buttons")
                    Labels
                }
                // Color Pickers
                VStack(alignment: .trailing) {
                    ColorPickerWithFrame($viewModel.primaryTextColor)
                    ColorPickerWithFrame($viewModel.weekdayHeaderTextColor)
                    ColorPickerWithFrame($viewModel.currentDayTextColor)
                    ColorPickerWithFrame($viewModel.selectedDayTextColor)
                    ColorPickerWithFrame($viewModel.prevMonthDaysTextColor)
                    ColorPickerWithFrame($viewModel.currentMonthDaysTextColor)
                    ColorPickerWithFrame($viewModel.nextMonthDaysTextColor)
                }
            }
            Spacer()
        }
        .frame(width: 300)
        .padding(.vertical, 20)
    }
}
