//
//  CalculatorButtonsError.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  4EDD24CD-102E-4CE6-A8BA-BB82A3726CB0
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// Specific error when button is not found. Kept with Views for modularity.
enum CalculatorButtonsError: Error, CustomStringConvertible {
    case buttonNotFound(String)
    
    var description: String {
        switch self {
        case .buttonNotFound(let message):
            return "Button not in liveButtons dictionary: \(message)"
        }
    }
}
