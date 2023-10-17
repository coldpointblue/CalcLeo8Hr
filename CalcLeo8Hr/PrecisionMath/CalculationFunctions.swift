import Foundation

// MARK: - Core Calculation Functions

struct CalculationFunctions {
    static let fixedDecimals = 16
    static let decimalPlaces : Decimal = Decimal(sign: .plus, exponent:  CalculationFunctions.fixedDecimals, significand: Decimal(10))
    
    /// Compute precise percent change between two numbers given as strings
    func precisePercent(_ numerator: String, _ denominator: String) -> String {
        let calculation = (preciseRatio(numerator, denominator) * 100) - 100
        let result = ((calculation * 100).wholePart) / 100
        return (result.isSignMinus ? "" : "+") + "\(result)"
    }
    
    /// Compute a precise ratio between two numbers given as strings, returning Decimal
    func preciseRatio(_ numerator: String, _ denominator: String) -> Decimal {
        guard let firstNumber = Decimal(string: numerator),
              let secondNumber = Decimal(string: denominator) else {
            return Decimal(0)
        }
        let decimalPlaces = CalculationFunctions.decimalPlaces
        let calculation = ((decimalPlaces * firstNumber) / (secondNumber * decimalPlaces))
        return ((calculation * decimalPlaces).wholePart) / decimalPlaces
    }
    
    // Compute precise division by multiplicying Reciproacl, returning String
    func preciseDivision(_ numerator: String, _ denominator: String) -> String {
        guard let firstNumber = Decimal(string: numerator),
              let secondNumber = Decimal(string: denominator) else {
            return "0.00" // Zero when numbers are not converted to Decimal
        }
        
        let decimalPlaces = CalculationFunctions.decimalPlaces
        let reciprocalOfDenominator = Decimal().safeReciprocal(secondNumber)
        
        let calculation = (firstNumber * reciprocalOfDenominator) // Division
        
        // Truncate to fixed decimals
        let result = ((calculation * decimalPlaces).wholePart) / decimalPlaces
        return result.digitsSeenPadded(CalculationFunctions.fixedDecimals)
    }
}
