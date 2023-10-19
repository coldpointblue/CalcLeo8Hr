import SwiftUI

/// Represents the ViewModel in MVVM for the calculator
class CalculatorViewModel: ObservableObject {
    @Published private(set) var model: CalculatorModel = CalculatorModel()
    @ObservedObject var configViewModel: ConfigurationViewModel = ConfigurationViewModel.shared
    
    @Published private(set) var finalAnswer: Double = 0.0
    @Published var displayValue: String = "0"
    
    func handleButtonPress(button: CalculatorButton) throws {
        let notYetImplemented = " operation not implemented"
        
        // If "Error" is displayed, ignore all except for "AC"
        guard displayValue != "Error" || (displayValue == "Error" && button == .standard(.clear)) else {
            flashIgnore()
            return
        }
        
        switch button {
        case .standard(let str):
            switch str {
            case .clear:
                displayValue = "0"
            case .negate:
                Logger.debugInfo("Negate" + notYetImplemented)
            case .bitcoin:
                throw GenericError.invalidOperation("Bitcoin web call" + notYetImplemented)
            case .decimalPoint:
                Logger.debugInfo("Decimal point" + notYetImplemented)
            case .equal:
                Logger.debugInfo("Equals" + notYetImplemented)
            }
            
        case .operation(let op):
            switch op {
            case .divide, .multiply, .subtract, .add:
                Logger.debugInfo("Arithmetic" + notYetImplemented)
            case .sine, .cosine:
                Logger.debugInfo("\(op.symbol)" + notYetImplemented)
            case .none:
                Logger.debugInfo("None operation" + notYetImplemented)
            }
        case .digit(let num):
            switch num {
            case .zero:
                if displayValue != "0" { displayValue += button.description } else {
                    flashIgnore()
                }
            default:
                displayValue = (displayValue == "0") ? button.description : displayValue + button.description
            }
        }
    }
    
    func setDisplayValue(_ value: String) {
        displayValue = value
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
