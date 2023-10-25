//
//  Logging.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  F5F44E09-59CD-404F-AB04-6D5D2999DAC9
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import os

/// Supported log message types
enum CalculatorLogType {
    case info, error, warning
}

struct Logger {
    static func log(_ message: String, type: CalculatorLogType = .info) {
        switch type {
        case .info:
            os_log("INFO: %{public}@", message)
        case .error:
            os_log("ERROR: %{public}@", message)
        case .warning:
            os_log("WARNING: %{public}@", message)
        }
    }
    
    /// Logs for debug builds only
    static func debugInfo(_ message: String) {
#if DEBUG
        Logger.log(message, type: .info)
#endif
    }
}
