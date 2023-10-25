//
//  OperationEnum.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  D2F57482-B6D3-494B-9878-A357BA5FA737
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI
/// Operation enum is a utility shared between Views and Model, because DRY

/// Enumerates supported mathematical operations.
enum Operation: String, CaseIterable, Hashable {
    case none = ""
    case divide = "÷"
    case multiply = "×"
    case subtract = "-"
    case add = "+"
    case sine = "sin"
    case cosine = "cos"
    
    /// Returns the symbol for the operation.
    var symbol: String { rawValue }
}
