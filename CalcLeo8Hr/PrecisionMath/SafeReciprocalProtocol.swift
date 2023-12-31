//
//  SafeReciprocalProtocol.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  62C4A11C-F999-42FF-9D9A-61F7016ADA81
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import Foundation

// MARK: - Safe Reciprocal Protocol and Implementation

protocol SafeReciprocalProtocol {
    static func / (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static func != (lhs: Self, rhs: Self) -> Bool
    init(_ value: Int)
}

extension Decimal: SafeReciprocalProtocol {}
extension Double: SafeReciprocalProtocol {}
extension Int: SafeReciprocalProtocol {}

extension SafeReciprocalProtocol {
    func safeDivision(_ value: Self) -> Self {
        guard value != Self(0) else { return Self(0) }
        
        if Self.self == Int.self { return self / value }
        return self * safeReciprocal(value)
    }
    
    /**
     Safely compute Reciprocal returning 0 instead of NaN for division by zero.
     
     - Parameter value: Number whose reciprocal will be calculated
     - Returns: Reciprocal if the number is not zero, otherwise zero
     */
    func safeReciprocal<T: SafeReciprocalProtocol>(_ value: T) -> T {
        return value != T(0) ? (T(1) / value) : T(0) // Instead of T.nan
    }
}
