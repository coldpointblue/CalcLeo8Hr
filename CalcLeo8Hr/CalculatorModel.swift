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
