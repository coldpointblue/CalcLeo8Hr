//
//  CalculatorModel.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  AC4D5E3D-D889-4197-9E0F-1339F5FB1E38
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import Foundation

enum CalculatorError: Error {
    case divideByZero
    
    var description: String {
        switch self {
        case .divideByZero:
            return "Division by zero is invalid."
        }
    }
}

struct CalculatorModel {
    var currentTotal: Decimal = 0.0
    var givenNumber: Decimal = 0.0
    var operation: Operation = .none
    
    /// Arithmetic performed then updates currentTotal
    mutating func performOperation() {
        do {
            try calculateResult()
        } catch CalculatorError.divideByZero {
            Logger.log("Cannot divide by zero.", type: .error)
            currentTotal = Decimal.nan
        } catch {
            Logger.log("An unknown error occurred.", type: .error)
        }
    }
    
    private mutating func calculateResult() throws {
        switch operation {
        case .add:
            currentTotal += givenNumber
        case .subtract:
            currentTotal -= givenNumber
        case .multiply:
            currentTotal *= givenNumber
        case .divide:
            // try handlePreciseDivision()
            currentTotal = try divideImprecise(dividend: currentTotal, divisor: givenNumber)
        case .sine:
            currentTotal = sin(givenNumber.asDouble).asDecimal
        case .cosine:
            currentTotal = cos(givenNumber.asDouble).asDecimal
        case .none:
            currentTotal = givenNumber
        }
    }
    
    private mutating func handlePreciseDivision() throws {
        do {
            let result = try CalculationFunctions.preciseDivision(currentTotal, givenNumber)
            currentTotal = result.asTuple.0
        } catch CalculatorError.divideByZero {
            currentTotal = Decimal.nan
        } catch {
            throw GenericError.invalidOperation("Unknown Error within Division")
        }
    }
    
    /// Normal division that handles division by zero.
    func divideImprecise(dividend: Decimal, divisor: Decimal) throws -> Decimal {
        guard divisor != 0.0 else {
            throw CalculatorError.divideByZero
        }
        return dividend / divisor
    }
    
    mutating func negate(_ valueToNegate: ValueToNegate) {
        switch valueToNegate {
        case .currentTotal:
            currentTotal = -currentTotal
        case .givenNumber:
            givenNumber = -givenNumber
        }
    }
    
    mutating func reset() {
        currentTotal = 0.0
        givenNumber = 0.0
        operation = .none
    }
}

enum ValueToNegate {
    case currentTotal
    case givenNumber
}
