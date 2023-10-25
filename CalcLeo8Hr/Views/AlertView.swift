//
//  AlertView.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  57FD66B2-D638-4335-92CA-30827F6B6854
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

enum AlertRecommended: String {
    case defaultAlert
    case complexAlert
}

func customAlert(title: String, message: String, dismissButtonLabel: String) -> Alert {
    return Alert(
        title: Text(title),
        message: Text(message),
        dismissButton: .default(Text(dismissButtonLabel))
    )
}

func checkCurrentStatus() -> AlertRecommended {
    // TODO: Add logic to check variables for problems to return a specific alert
    return AlertRecommended.complexAlert
}

func alertSpecifics() -> Alert {
    let problemsReported = checkCurrentStatus()
    let continueLabel = LocalizedKey.alertContinueButtonLabel.inUse
    let title, message: String
    
    switch problemsReported {
    case .complexAlert:
        let variableStatus = "Noooooooo!"
        message = String(format: LocalizedKey.alertComplexMessage.inUse, variableStatus)
        title = LocalizedKey.alertComplexTitle.inUse
    default:
        title = LocalizedKey.alertMistakeTitle.inUse
        message = LocalizedKey.alertMistakeMessage.inUse
    }
    return customAlert(title: title, message: message, dismissButtonLabel: continueLabel)
}
