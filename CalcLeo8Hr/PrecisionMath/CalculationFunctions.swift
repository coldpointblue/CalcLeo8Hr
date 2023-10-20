import Foundation

// MARK: - Core Calculation Functions

struct CalculationFunctions {
    static var fixedDecimals = 16 // Indicate the precision level
    static var decimalPlaces: Decimal { pow(10, fixedDecimals) }
    
    /// Compute precise percent change between two numbers given as strings
    static func precisePercent(_ numerator: String, _ denominator: String) -> String {
        let calculation = (preciseRatio(numerator, denominator) * 100) - 100
        let result = ((calculation * 100).wholePart) / 100
        return (result.isSignMinus ? "" : "+") + "\(result)"
    }
    
    /// Compute a precise ratio between two numbers given as strings, returning Decimal
    static func preciseRatio(_ numerator: String, _ denominator: String) -> Decimal {
        guard let firstNumber = Decimal(string: numerator),
              let secondNumber = Decimal(string: denominator) else {
            return Decimal(0)
        }
        let decimalPlaces = CalculationFunctions.decimalPlaces
        let calculation = ((decimalPlaces * firstNumber) / (secondNumber * decimalPlaces))
        return ((calculation * decimalPlaces).wholePart) / decimalPlaces
    }
    
    enum PrecisionDivisionResult {
        case valid(Decimal, String)
        case error(String)
        
        // To choose result type, throws an error if it fails. i.e. result.asTuple.0 or 1
        func asTupleThrowingErr() throws -> (Decimal, String) {
            if let result = createTuple() { return result }
            throw CalculatorError.divideByZero
        }
        
        var asTuple: (Decimal, String) {
            return createTuple() ?? (Decimal.nan, "Not a Number")
        }
        
        /// - Returns: Optional tuple of Decimal and String.
        private func createTuple() -> (Decimal, String)? {
            switch self {
            case .valid(let decimal, let string):
                return (decimal, string)
            case .error(_):
                return nil
            }
        }
    }
    
    /// Precisely divides two Decimal numbers by multiplying Reciprocal. Returns (#, String).
    /// - Parameters:
    ///   - numerator: Numerator in Decimal.
    ///   - denominator: Denominator in Decimal.
    /// - Returns: Tuple (resultTruncated, fixedLengthString), Decimal and String.
    static func preciseDivision(_ numerator: Decimal, _ denominator: Decimal) throws -> PrecisionDivisionResult {
        guard denominator != 0 else {
            throw CalculatorError.divideByZero
        }
        
        let decimalPlaces = CalculationFunctions.decimalPlaces
        let reciprocalOfDenominator = Decimal().safeReciprocal(denominator)
        guard !reciprocalOfDenominator.isNaN else {
            return PrecisionDivisionResult.error("Not a Number")
        }
        
        let preciseCalculation = (numerator * reciprocalOfDenominator) // Division
        // Truncate to fixed decimals
        let truncated = ((preciseCalculation * decimalPlaces).wholePart) / decimalPlaces
        let resultFixedLength = truncated.digitsSeenPadded(CalculationFunctions.fixedDecimals)
        
        return PrecisionDivisionResult.valid(preciseCalculation, resultFixedLength)
    }
}
