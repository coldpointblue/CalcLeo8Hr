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
    
    /// Converts a Decimal to String truncated to maximum number of characters.
    ///
    /// - Parameters:
    ///   - value: Decimal value to convert.
    ///   - maxCharacters: Maximum number of characters for output string.
    /// - Returns: String representing Decimal, truncated to `maxCharacters` length.
    func fixedLength(_ maxCharacters: Int) -> String {
        guard maxCharacters > 0, self != 0.0, !self.isNaN else {
            return (maxCharacters > 0) ? "0" : ""
        }
        
        let negativePrefix = (self < 0) ? "-" : ""
        let absoluteValue = abs(self)
        
        let integerPartStr = String(describing: absoluteValue.wholePart)
        // Truncate string when integer part length not within maxCharacters
        if integerPartStr.count >= maxCharacters {
            return String(integerPartStr.prefix(maxCharacters))
        }
        
        // Extract fractional part
        let fractionalPart = absoluteValue - absoluteValue.wholePart
        // Early exit if no room for fractional part or fractionalPart is zero
        guard fractionalPart != 0 else {
            return integerPartStr
        }
        
        // Calculate available length for fractional part; +1 reserved for decimal point
        let availableLengthForFraction = maxCharacters - integerPartStr.count - 1
        // Calculate truncated fractional part
        let fractionPartSpaces = pow(10.0, Double(availableLengthForFraction)).asDecimal
        let truncatedFractionalPart = NSDecimalNumber(decimal: (fractionalPart * fractionPartSpaces).wholePart).intValue
        // Convert truncated fractional part to string to append it to the integer part
        let fractionalPartStr = padWithZeros(truncatedFractionalPart, availableLengthForFraction)
        
        // Combine integer and fractional parts with a decimal point
        return negativePrefix + "\(integerPartStr).\(fractionalPartStr)"
    }
    
    func padWithZeros(_ number: Int, _ length: Int) -> String {
        let numberStr = String(number)
        guard numberStr.count < length else {
            return String(numberStr.prefix(length))
        }
        
        let paddingCount = length - numberStr.count
        return String(repeating: "0", count: paddingCount) + numberStr
    }
    
    /// Whole part of decimal, rounding down positive numbers and rounding up negatives
    var wholePart: Self {
        var result = Decimal()
        var mutableSelf = self
        NSDecimalRound(&result, &mutableSelf, 0, self >= 0 ? .down : .up)
        return result
    }
    
    var asDouble : Double { NSDecimalNumber(decimal: self).doubleValue }
}

extension Double {
    var asDecimal : Decimal { Decimal(string: String(self)) ?? Decimal(0) }
}
