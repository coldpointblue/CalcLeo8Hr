import SwiftUI

/// Represents the ViewModel in MVVM for the calculator
class CalculatorViewModel: ObservableObject {
    @Published private(set) var model: CalculatorModel = CalculatorModel()
    @ObservedObject var configViewModel: ConfigurationViewModel = ConfigurationViewModel.shared
    
    private var isChainingOperations = false
    @Published var displayValue: String = "0"
    
    let zeroStr = "0"
    let decimalPoint = "."
    let errorStr = "Error"
    let notYetImplemented = " operation not implemented"
    
    func handleButtonPress(button: CalculatorButton) throws {
        if displayValue == errorStr && button != .standard(.clear) {
            flashIgnore()
            return
        }
        
        switch button {
        case .standard(let str):
            try handleStandardButton(str)
        case .operation(let op):
            try handleOperationButton(op)
        case .digit(let num):
            handleDigitButton(num)
        }
    }
    
    func updateDisplayFromDecimal(_ newDecimal: Decimal) {
        if !displayValue.hasSuffix(decimalPoint) {
            displayValue = (0 == newDecimal) ? zeroStr : newDecimal.fixedLengthFractionsStr(CalculationFunctions.fixedDecimals)
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
            setGivenNumber(getDisplayDecimal())
            model.performOperation()
            model.operation = .none
            updateDisplayFromDecimal(model.currentTotal)
        }
    }
    
    private func handleOperationButton(_ operationTapped: Operation) throws {
        guard operationTapped != .none else {
            Logger.debugInfo("None operation" + notYetImplemented)
            return
        }
        // placeholder for logic
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
            if displayValue != zeroStr { displayValue += num.rawValue } else {
                flashIgnore()
            }
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
    
    private func setOperation(_ operation: Operation) {
        model.performOperation()
        model.operation = operation
    }
    
    private func computeFinalAnswer() {
        model.performOperation()
        finalAnswer = model.currentTotal
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
