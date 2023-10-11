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
