//
//  CalculatorButton.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  8D2801DE-1E3B-4F7C-A2F8-75EBC83518FF
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// Enum representing calculator button labels
enum CalculatorButton: CustomStringConvertible, Hashable {
    
    // Types of buttons
    case operation(Operation) // Note: Operation enum separate, DRY
    case standard(Standard)
    case digit(Digit)
    
    // MARK: - Nested Enums
    
    /// Enumerates standard buttons like AC, ±, etc.
    enum Standard: String, CaseIterable, Hashable {
        case clear = "AC", negate = "±", bitcoin = "₿", decimalPoint = ".", equal = "="
        var symbol: String { rawValue }
    }
    
    /// Enumerates number buttons 0-9
    enum Digit: String, CaseIterable, Hashable {
        case zero = "0", one = "1", two = "2", three = "3", four = "4",
             five = "5", six = "6", seven = "7", eight = "8", nine = "9"
        var symbol: String { rawValue }
    }
    
    // MARK: - Properties
    
    var description: String {
        switch self {
        case .operation(let op): return op.symbol
        case .standard(let standard): return standard.symbol
        case .digit(let digit): return digit.symbol
        }
    }
    
    func colorByType() -> Color {
        switch self {
        case .operation: return CalcColor.operation
        case .standard: return CalcColor.utility
        case .digit: return CalcColor.digit
        }
    }
    
    /// Returns array of all possible CalculatorButtons
    static var allCases: [CalculatorButton] {
        let standardButtons = Standard.allCases.map(CalculatorButton.standard)
        let operationButtons = Operation.allCases.map(CalculatorButton.operation)
        let digitButtons = Digit.allCases.map(CalculatorButton.digit)
        
        return standardButtons + operationButtons + digitButtons
    }
    
    // MARK: - Hashable Conformance
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .operation(let operation): hasher.combine(operation)
        case .standard(let standard): hasher.combine(standard)
        case .digit(let digit): hasher.combine(digit)
        }
    }
    
    static func == (lhs: CalculatorButton, rhs: CalculatorButton) -> Bool {
        switch (lhs, rhs) {
        case (.operation(let leftOperation), .operation(let rightOperation)):
            return leftOperation == rightOperation
        case (.standard(let leftStandard), .standard(let rightStandard)):
            return leftStandard == rightStandard
        case (.digit(let leftDigit), .digit(let rightDigit)):
            return leftDigit == rightDigit
        default:
            return false
        }
    }
}
