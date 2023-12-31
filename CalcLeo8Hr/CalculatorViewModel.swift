//
//  CalculatorViewModel.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  530DA98C-C41C-472B-81B6-AD78457599C8
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// Represents the ViewModel in MVVM for the calculator
class CalculatorViewModel: ObservableObject {
    @Published private(set) var model: CalculatorModel = CalculatorModel()
    @ObservedObject var configViewModel: ConfigurationViewModel = ConfigurationViewModel.shared
    
    private var isChainingOperations = false
    @Published var displayValue: String = "0"
    
    let zeroDecimal = Decimal(0)
    let zeroStr = "0"
    let decimalPoint = "."
    let errorStr = "Error"
    
    func handleButtonPress(button: CalculatorButton) throws {
        if displayValue == errorStr && button != .standard(.clear) {
            flashIgnore()
            return
        }
        
        switch button {
        case .standard(let standardButtonType):
            try handleStandardButton(standardButtonType)
        case .operation(let operationButtonType):
            guard operationButtonType != .none else {  return }
            try handleOperationButton(operationButtonType)
        case .digit(let numberButtonType):
            handleDigitButton(numberButtonType)
        }
    }
    
    func updateDisplayFromDecimal(_ newDecimal: Decimal) {
        if !displayValue.hasSuffix(decimalPoint) {
            displayValue = (zeroDecimal == newDecimal) ? zeroStr : newDecimal.fixedLengthFractionsStr(CalculationFunctions.fixedDecimals)
        } else {
            displayValue += zeroStr
        }
    }
    
    // Private methods
    
    private func handleStandardButton(_ standardTapped: CalculatorButton.Standard) throws {
        switch standardTapped {
        case .clear:
            resetCalculator()
        case .negate:
            if let displayNumInput = Decimal(string: displayValue), displayNumInput != 0 {
                setGivenNumber(displayNumInput)
                model.negate(.givenNumber)
                updateDisplayFromDecimal(model.givenNumber)
            } else { flashIgnore() }
        case .bitcoin:
            throw GenericError.invalidOperation("Bitcoin operation not yet implemented")
        case .decimalPoint:
            // Consider clear to begin new operation with point, while not zero shown?
            displayValue.contains(decimalPoint) ? flashIgnore() : (displayValue += decimalPoint)
        case .equal:
            executePendingOperation()
        }
    }
    
    private func handleOperationButton(_ operationTapped: Operation) throws {
        if model.operation != .none {
            executePendingOperation()
        } else {
            // Skip updating display
            setGivenNumber(getDisplayDecimal())
            model.performOperation()
        }
        // Set new operation
        model.operation = operationTapped
        isChainingOperations = true
    }
    
    private func handleDigitButton(_ num :CalculatorButton.Digit) {
        // Handle chaining operations and building new numbers
        if isChainingOperations {
            // Reset the isChainingOperations flag
            isChainingOperations = false
            
            // Update displayValue to zero if it doesn't end with a decimal point
            if !displayValue.hasSuffix(decimalPoint) { displayValue = zeroStr }
        }
        
        switch num {
        case .zero:
            if displayValue == zeroStr { flashIgnore() } else { displayValue += num.rawValue }
        default:
            displayValue = (displayValue == zeroStr) ? num.rawValue : displayValue + num.rawValue
        }
    }
    
    // Briefly display an underscore and then remove it
    private func flashIgnore() {
        let currentDisplay = self.displayValue
        self.displayValue = "_"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.displayValue = currentDisplay
        }
    }
    
    private func setGivenNumber(_ newNumber: Decimal) {
        model.givenNumber = newNumber
    }
    
    private func getDisplayDecimal()-> Decimal {
        guard let decimalShown = Decimal(string: displayValue) else {
            Logger.debugInfo("Display not Decimal value: \(displayValue)")
            return zeroDecimal
        }
        return decimalShown
    }
    
    private func executePendingOperation() {
        setGivenNumber(getDisplayDecimal())
        model.performOperation()
        model.operation = .none
        updateDisplayFromDecimal(model.currentTotal)
    }
    
    private func resetCalculator() {
        model.reset()
        model.operation = .none
        isChainingOperations = false
        updateDisplayFromDecimal(0)
    }
}

/// `ConfigurationViewModel` observable object class to configure visible calculator buttons.
/// Requires CalculatorButton.allCases.count defined beforehand for simple automatic use.
class ConfigurationViewModel: ObservableObject {
    /// Published property for the state of visible buttons whose changes will be observed.
    @Published var visibleButtons: [CalculatorButton: Bool]
    
    /// A singleton shared instance
    static let shared = ConfigurationViewModel()
    
    /// Create shared instance of `ConfigurationViewModel`.
    ///
    /// - Parameter visibleButtons: Dictionary representing visibility of calculator buttons.
    private init(_ initiallyVisibleButtons: [CalculatorButton: Bool]? = nil) {
        self.visibleButtons = initiallyVisibleButtons ?? Dictionary(uniqueKeysWithValues: CalculatorButton.allCases.map { ($0, true) })
    }
    
    func resetAllButtonsLive() {
        self.visibleButtons.keys.forEach { self.visibleButtons[$0] = true }
    }
}
