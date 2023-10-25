//
//  DisplayView.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  A92DA278-2E50-4DF4-9A94-CF09276F5BA7
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// View for the calculator display screen
struct DisplayView: View {
    @Binding var displayValue: String
    
    let numberFontSize: CGFloat = 70
    let indentRight: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 0) {
            Text(displayValue)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: numberFontSize))
                .background(CalcColor.display)
                .padding(.trailing, indentRight)
                .accessibilityIdentifier("displayValue") // For UI tests
        }
        .modifier(DisplayViewStyle())
    }
}

struct DisplayViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(CalcColor.display)
            .padding(1)
            .border(CalcColor.display, width: 1)
            .minimumScaleFactor(0.5)
    }
}
