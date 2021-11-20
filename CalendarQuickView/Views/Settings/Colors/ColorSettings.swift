//
//  ColorSettings.swift
//  CalendarQuickView
//
//  Created by Michael Ellis on 11/5/21.
//

import SwiftUI

struct ColorSettings: View {
    
    @EnvironmentObject var viewModel: CalendarViewModel
    @State var isShowingPopover: [Bool] = [Bool](repeating: false, count: 7)
    
    func ColorLabel(index: Int, _ color: Color, _ text: String, value: Binding<String>) -> some View {
        HStack {
            Text(text).frame(height: 25).foregroundColor(AppColors.contrast.color)
            Spacer()
            Button(action: {
                isShowingPopover[index] = true
            }) {
                color.frame(width: 25, height: 25)
                    .cornerRadius(4)
            }
            .buttonStyle(PlainButtonStyle())
            .popover(isPresented: $isShowingPopover[index], attachmentAnchor: PopoverAttachmentAnchor.point(.bottom), arrowEdge: .bottom) {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(AppColors.allCases, id:\.self) { color in
                            HStack(spacing: 0) {
                                Text(color.rawValue.capitalized)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .foregroundColor(AppColors.contrast.color)
                                Spacer()
                                Color(color.rawValue)
                                    .frame(width: 40)
                                    .cornerRadius(4)
                                    .padding(.trailing, 6)
                            }
                            .frame(width: 130, height: 30)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isShowingPopover[index] = false
                                value.wrappedValue = color.rawValue
                            }
                            Divider()
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Text("Reset All")
                    .font(.title3)
                CalendarButton(imageName: "arrow.triangle.2.circlepath", animation: .linear, color: ColorStore.shared.buttonColor, size: viewModel.buttonSize) {
                    ColorStore.shared._titleTextColor = "contrast"
                    ColorStore.shared._eventTextColor = "contrast"
                    ColorStore.shared._buttonColor = "contrast"
                    
                    ColorStore.shared._currentMonthText = "contrast"
                    ColorStore.shared._currentMonthColor = "stone"
                    
                    ColorStore.shared._otherMonthText = "contrast"
                    ColorStore.shared._otherMonthColor = "stone"
                }
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("General Colors")
                        .font(.title3)
                    Spacer()
                }
                Divider()
                ColorLabel(index: 0, ColorStore.shared.titleTextColor, "Calendar Title Text", value: ColorStore.shared.$_titleTextColor)
                ColorLabel(index: 1, ColorStore.shared.eventTextColor, "Event Text", value: ColorStore.shared.$_eventTextColor)
                ColorLabel(index: 2, ColorStore.shared.buttonColor, "Button Highlight", value: ColorStore.shared.$_buttonColor)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Current Month's Days")
                        .font(.title3)
                    Spacer()
                }
                Divider()
                ColorLabel(index: 4, ColorStore.shared.currentMonthText, "Text", value: ColorStore.shared.$_currentMonthText)
                ColorLabel(index: 3, ColorStore.shared.currentMonthColor, "Background", value: ColorStore.shared.$_currentMonthColor)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Other Month's Days")
                        .font(.title3)
                    Spacer()
                }
                Divider()
                ColorLabel(index: 5, ColorStore.shared.otherMonthText, "Text", value: ColorStore.shared.$_otherMonthText)
                ColorLabel(index: 6, ColorStore.shared.otherMonthColor, "Background", value: ColorStore.shared.$_otherMonthColor)
            }
            Spacer()
        }
        .frame(width: 250)
        .padding(.vertical, 20)
    }
}
