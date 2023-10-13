import SwiftUI

/// Specific error when button is not found. Kept with Views for modularity.
enum CalculatorButtonsError: Error, CustomStringConvertible {
    case buttonNotFound(String)
    
    var description: String {
        switch self {
        case .buttonNotFound(let message):
            return "Button not in liveButtons dictionary: \(message)"
        }
    }
}
