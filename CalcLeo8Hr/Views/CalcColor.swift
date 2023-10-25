//
//  CalcColor.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  A886802D-9B93-4B86-8FFD-CA4A5A7C4420
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// Struct for calculator color scheme
struct CalcColor {
    enum ColorScheme {
        case `default`
        case alternate
    }
    
    static var activeColorScheme: ColorScheme = .default
    
    static var display: Color { activeColorScheme == .alternate ? .black : .white }
    static var outside: Color { activeColorScheme == .alternate ? .white : .black }
    static var utility: Color { activeColorScheme == .alternate ? Color(.systemGray5) : Color(.systemGray) }
    static var digit: Color { activeColorScheme == .alternate ? Color(.systemGray4) : Color(.systemGray2) }
    static var operation: Color { activeColorScheme == .alternate ? .blue : .orange }
    static var buttonBorder: Color { activeColorScheme == .alternate ? .white : .black }
    static var symbol: Color { activeColorScheme == .alternate ? .black : .white }
    
    /// Returns display color based on the orientation to fill outside
    static func edgeDisplay(for orientation: CGSize) -> Color {
        return orientation.width > orientation.height ? outside : display
    }
    
    static func toggleScheme() {
        activeColorScheme = (activeColorScheme == .default) ? .alternate : .default
    }
    
}
