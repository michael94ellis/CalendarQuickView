//
//  ColorSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct ColorSettings: View {
    // Saved Colors
    @AppStorage(AppStorageKeys.currentMonthDaysColor) private var currentMonthDaysColor: Color = Color.blue
    @AppStorage(AppStorageKeys.prevMonthDaysColor) private var prevMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.nextMonthDaysColor) private var nextMonthDaysColor: Color = Color.lightGray
    @AppStorage(AppStorageKeys.currentDayColor) private var currentDayColor: Color = Color.green
    @AppStorage(AppStorageKeys.selectedDayColor) private var selectedDayColor: Color = Color.yellow
    
    func TextWithFrame(_ text: String) -> some View {
        Text(text).frame(height: 25)
    }
    func ColorPickerWithFrame(_ colorBinding: Binding<Color>) -> some View {
        ColorPicker("", selection: colorBinding).frame(height: 25)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Day Colors").font(.title2).fontWeight(.bold)
            HStack {
                // Labels
                VStack(alignment: .leading) {
                    TextWithFrame("Current")
                    TextWithFrame("Selected")
                    TextWithFrame("Previous Month")
                    TextWithFrame("Current Month")
                    TextWithFrame("Next Month")
                }
                // Color Pickers
                VStack(alignment: .trailing) {
                    ColorPickerWithFrame($currentDayColor)
                    ColorPickerWithFrame($selectedDayColor)
                    ColorPickerWithFrame($prevMonthDaysColor)
                    ColorPickerWithFrame($currentMonthDaysColor)
                    ColorPickerWithFrame($nextMonthDaysColor)
                }
            }
        }
    }
    
}
