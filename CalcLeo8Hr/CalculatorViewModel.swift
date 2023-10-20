import SwiftUI

/// Represents the ViewModel in MVVM for the calculator
class CalculatorViewModel: ObservableObject {
    @Published private(set) var model: CalculatorModel = CalculatorModel()
    @ObservedObject var configViewModel: ConfigurationViewModel = ConfigurationViewModel.shared
    
    @Published private(set) var finalAnswer: Decimal = 0.0
    private var pendingOperation: Operation = .none
    private var isNewNumber = false
    @Published var displayValue: String = "0"
    
    let zeroStr = "0"
    let notYetImplemented = " operation not implemented"
    
    func handleButtonPress(button: CalculatorButton) throws {
        guard !isErorrIgnoringUnlessAC(button) else { return }
        
        switch button {
        case .standard(let str):
            try handleStandardButton(str)
        case .operation(let op):
            try handleOperationButton(op)
        case .digit(let num):
            handleDigitButton(num)
        }
    }
    
    func setDisplayValue(_ value: String) {
        displayValue = value
    }
    
    // Private methods
    
    private func isErorrIgnoringUnlessAC(_ button: CalculatorButton) -> Bool {
        // If "Error" is displayed, ignore all except for "AC"
        guard displayValue != "Error" || (displayValue == "Error" && button == .standard(.clear)) else {
            flashIgnore()
            return true
        }
        
        return false
    }
    
    private func handleStandardButton(_ button: CalculatorButton.Standard) throws {
        switch button {
        case .clear:
            resetCalculator()
        case .negate:
            if let displayNumInput = Decimal(string: displayValue), displayNumInput != 0 {
                setGivenNumber(displayNumInput)
                model.negate(.givenNumber)
                finalAnswer = model.givenNumber
                updateDisplayValue(finalAnswer)
            } else { flashIgnore() }
        case .bitcoin:
            throw GenericError.invalidOperation("Bitcoin operation not yet implemented")
        case .decimalPoint:
            Logger.debugInfo("Decimal point" + notYetImplemented)
        case .equal:
            try computeFinalAnswer()
        }
    }
    
    private func handleOperationButton(_ operation: Operation) throws {
        guard operation != .none else {
            Logger.debugInfo("None operation" + notYetImplemented)
            return
        }
        // placeholder for logic
    }
    
    private func handleDigitButton(_ num :CalculatorButton.Digit) {
        if !isNewNumber {
            isNewNumber.toggle()
            displayValue = zeroStr
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
    
    private func setGivenNumber(_ num: Double) {
        model.givenNumber = num
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
        finalAnswer = 0.0
        pendingOperation = .none
        isNewNumber = false
        displayValue = zeroStr
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
