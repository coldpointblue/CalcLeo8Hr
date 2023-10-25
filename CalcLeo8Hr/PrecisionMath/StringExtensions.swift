//
//  StringExtensions.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  ED6E2252-AAFB-4DF4-9F71-98B269625844
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

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
