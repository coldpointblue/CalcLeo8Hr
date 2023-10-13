import SwiftUI
/// Operation enum is a utility shared between Views and Model, because DRY

/// Enumerates supported mathematical operations.
enum Operation: String, CaseIterable, Hashable {
    case none = ""
    case divide = "÷"
    case multiply = "×"
    case subtract = "-"
    case add = "+"
    case sine = "sin"
    case cosine = "cos"
    
    /// Returns the symbol for the operation.
    var symbol: String { rawValue }
}
