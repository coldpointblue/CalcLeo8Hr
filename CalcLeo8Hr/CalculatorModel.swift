import Foundation

enum CalculatorError: Error {
    case divideByZero
}

struct CalculatorModel {
    var currentTotal: Double = 0.0
    var givenNumber: Double = 0.0
    var operation: Operation = .none
    
    /// Arithmetic performed then updates currentTotal
    mutating func performOperation() {
        do {
            switch operation {
            case .add:
                currentTotal += givenNumber
            case .subtract:
                currentTotal -= givenNumber
            case .multiply:
                currentTotal *= givenNumber
            case .divide:
                currentTotal = try divide(dividend: currentTotal, divisor: givenNumber)
            case .sine:
                currentTotal = sin(givenNumber)
            case .cosine:
                currentTotal = cos(givenNumber)
            case .none:
                break
            }
        } catch CalculatorError.divideByZero {
            Logger.log("Cannot divide by zero.", type: .error)
            currentTotal = Double.nan
        } catch {
            Logger.log("An unknown error occurred.", type: .error)
        }
    }
    
    /// Division that handles division by zero
    func divide(dividend: Double, divisor: Double) throws -> Double {
        guard divisor != 0.0 else {
            throw CalculatorError.divideByZero
        }
        return dividend / divisor
    }
    
    mutating func reset() {
        currentTotal = 0.0
        givenNumber = 0.0
        operation = .none
    }
}
