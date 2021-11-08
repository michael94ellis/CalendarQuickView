//
//  ColorThemes.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/7/21.
//

import SwiftUI

struct ColorThemes: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared
    
    var body: some View {
        HStack {
            Text("Rose Theme")
            Spacer()
            Button("", action: {
                // Backgrounds
                viewModel.currentMonthDaysBGColor = RoseTheme.rose
                viewModel.prevMonthDaysBGColor = RoseTheme.pink
                viewModel.nextMonthDaysBGColor = RoseTheme.pink
                viewModel.currentDayBGColor = RoseTheme.coral
                viewModel.selectedDayBGColor = RoseTheme.vermillion
                viewModel.weekDayHeaderBGColor = RoseTheme.pink
                // Foregrounds
                viewModel.primaryTextColor = RoseTheme.pink
                viewModel.currentMonthDaysTextColor = RoseTheme.lavendar
                viewModel.prevMonthDaysTextColor = RoseTheme.tart
                viewModel.nextMonthDaysTextColor = RoseTheme.tart
                viewModel.currentDayTextColor = RoseTheme.wood
                viewModel.selectedDayTextColor = RoseTheme.lavendar
                viewModel.weekdayHeaderTextColor = RoseTheme.wood
            })
        }
        HStack {
            Text("Yellow Theme")
            Spacer()
            Button("", action: {
                // Backgrounds
                viewModel.currentMonthDaysBGColor = SpringTheme.jonquil
                viewModel.prevMonthDaysBGColor = SpringTheme.stone
                viewModel.nextMonthDaysBGColor = SpringTheme.stone
                viewModel.currentDayBGColor = SpringTheme.mustard
                viewModel.selectedDayBGColor = SpringTheme.sky
                viewModel.weekDayHeaderBGColor = SpringTheme.stone
                // Foregrounds
                viewModel.primaryTextColor = SpringTheme.jet
                viewModel.currentMonthDaysTextColor = SpringTheme.jet
                viewModel.prevMonthDaysTextColor = SpringTheme.onyx
                viewModel.nextMonthDaysTextColor = SpringTheme.onyx
                viewModel.currentDayTextColor = SpringTheme.jet
                viewModel.selectedDayTextColor = SpringTheme.onyx
                viewModel.weekdayHeaderTextColor = SpringTheme.jet
            })
        }
        HStack {
            Text("Gray Theme")
            Spacer()
            Button("", action: {
                // Backgrounds
                viewModel.currentMonthDaysBGColor = Color.darkGray
                viewModel.prevMonthDaysBGColor = Color.lightGray
                viewModel.nextMonthDaysBGColor = Color.lightGray
                viewModel.currentDayBGColor = Color.white
                viewModel.selectedDayBGColor = Color.secondaryLabel
                viewModel.weekDayHeaderBGColor = Color.secondaryLabel
                // Foregrounds
                viewModel.primaryTextColor = Color.lightGray
                viewModel.currentMonthDaysTextColor = Color.lightGray
                viewModel.prevMonthDaysTextColor = Color.lightGray
                viewModel.nextMonthDaysTextColor = Color.lightGray
                viewModel.currentDayTextColor = Color.lightGray
                viewModel.selectedDayTextColor = Color.lightGray
                viewModel.weekdayHeaderTextColor = Color.lightGray
            })
        }
    }
}
