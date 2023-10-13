import SwiftUI

/// Struct for calculator color scheme
struct CalcColor {
    static let display = Color.white
    static let outside = Color.black
    static let utility = Color(.systemGray)
    static let digit = Color(.systemGray2)
    static let operation = Color.orange
    static let buttonBorder = Color.black
    static let symbol = Color.white
    
    /// Returns display color based on the orientation to fill outside
    static func edgeDisplay(for orientation: CGSize) -> Color {
        orientation.width > orientation.height ? outside : display
    }
}
