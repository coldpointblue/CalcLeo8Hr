import Foundation

/// Extension for handling precision in String representation of Decimals
extension String {
    /**
     Keep X digits for decimal numbers
     
     - Parameter forcedDigits: Kept number of digits after the decimal
     - Returns: New String with up to `forcedDigits` after its decimal point
     */
    func keepXDigits(_ forcedDigits: Int = 2) -> String {
        let digitLimit = max(0, min(forcedDigits, 16))
        
        let digitsKept = (Decimal(string: self) ?? Decimal(0.0)).digitsSeenPadded(digitLimit)
        return self.hasPrefix("+") ? "+" + digitsKept : digitsKept
    }
}
