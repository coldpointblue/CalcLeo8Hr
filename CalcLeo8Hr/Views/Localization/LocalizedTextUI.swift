import Foundation

enum LocalizedKey: String {
    case alertMistakeMessage
    case alertMistakeTitle
    case alertContinueButtonLabel
}

extension LocalizedKey {
    // Example use: LocalizedKey.alertMistakeMessage.inUse
    var inUse: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
