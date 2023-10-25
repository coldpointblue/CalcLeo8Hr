//
//  ErrorHandling.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  D43C5778-9CBE-4DD1-AF80-091FEDF5F3D5
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

enum GenericError: Error, CustomStringConvertible {
    case unknown(String)
    case invalidOperation(String)
    
    var description: String {
        switch self {
        case .unknown(let message):
            return message
        case .invalidOperation(let message):
            return "Invalid operation: \(message)"
        }
    }
}
