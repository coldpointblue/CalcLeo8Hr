//
//  LocalizedTextUI.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  F312DC5B-5A05-4629-B771-D4F3E33166EB
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import Foundation

enum LocalizedKey: String {
    case alertMistakeMessage
    case alertMistakeTitle
    
    case alertContinueButtonLabel
    
    case alertComplexMessage
    case alertComplexTitle
    
    case buttonConfigurationSheetTitle
}

extension LocalizedKey {
    // Example use: LocalizedKey.alertMistakeMessage.inUse
    var inUse: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
