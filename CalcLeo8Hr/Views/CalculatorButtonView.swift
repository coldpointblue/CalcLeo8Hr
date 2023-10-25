//
//  CalculatorButtonView.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  947F929D-58E6-41C2-8CE3-0FA3F8E1B0BB
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// View for individual calculator button
struct CalculatorButtonView: View {
    let button: CalculatorButton
    @Binding var displayValue: String
    let backgroundColor: Color
    
    let viewModel: CalculatorViewModel
    
    var body: some View {
        GeometryReader { geo in
            Button(action: handleButtonPress) {
                ZStack {
                    backgroundColor
                    Text(button.description)
                        .modifier(CalculatorButtonViewStyle())
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .border(CalcColor.buttonBorder, width: 1)
        }
    }
    
    func handleButtonPress() {
        do {
            try viewModel.handleButtonPress(button: button)
        } catch let error {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        Logger.log("An unexpected error occurred pressing button: \(error.localizedDescription)", type: .error)
        DispatchQueue.main.async {
            self.displayValue = "Error"
        }
    }
}

struct CalculatorButtonViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 40))
            .foregroundColor(CalcColor.symbol)
    }
}
