//
//  NumberFormatterManager.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  02BA2329-6A48-49EB-B4F2-75CC4DE89D42
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import Foundation

final class NumberFormatterManager {
    static let shared = NumberFormatterManager()
    private var fixedNumberFormatter: NumberFormatter
    private let queue = DispatchQueue(label: "com.CalcLeo8Hr.NumberFormatterManager")
    
    private init() {
        fixedNumberFormatter = NumberFormatter()
        fixedNumberFormatter.numberStyle = .decimal
    }
    
    func getFormatter(withDigits digits: Int) -> NumberFormatter {
        return queue.sync {
            fixedNumberFormatter.minimumFractionDigits = digits
            fixedNumberFormatter.maximumFractionDigits = digits
            return fixedNumberFormatter
        }
    }
}
