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
