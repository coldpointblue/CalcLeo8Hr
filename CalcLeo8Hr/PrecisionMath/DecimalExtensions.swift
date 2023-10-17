import Foundation

/// Extension for Decimal to handle precision and formatting
extension Decimal {
    /**
     Format decimal into string with fixed number of digits after its decimal point
     
     - Parameters:
     - digits: Number of digits after decimal point
     - fixedLengthTotal: Total length of string
     - Returns: String representing the decimal with enforced precision
     */
    func digitsSeenPadded(_ digits: Int, fixedLengthTotal: Int = 16) -> String {
        let formatter = NumberFormatterManager.shared.getFormatter(withDigits: digits)
        
        guard let formattedString = formatter.string(from: self as NSNumber) else {
            return "_.__"
        }
        
        let paddingCount = fixedLengthTotal - formattedString.count
        return paddingCount > 0 ? String(repeating: " ", count: paddingCount) + formattedString : formattedString
    }
    
    /// Whole part of the decimal, rounding down for positive numbers and rounding up for negatives
    var wholePart: Self {
        var result = Decimal()
        var mutableSelf = self
        NSDecimalRound(&result, &mutableSelf, 0, self >= 0 ? .down : .up)
        return result
    }
}
