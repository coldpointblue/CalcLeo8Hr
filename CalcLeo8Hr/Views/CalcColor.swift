import SwiftUI

/// Struct for calculator color scheme
struct CalcColor {
    enum ColorScheme {
        case `default`
        case alternate
    }
    
    static var activeColorScheme: ColorScheme = .default
    
    static var display: Color { activeColorScheme == .alternate ? .black : .white }
    static var outside: Color { activeColorScheme == .alternate ? .white : .black }
    static var utility: Color { activeColorScheme == .alternate ? Color(.systemGray5) : Color(.systemGray) }
    static var digit: Color { activeColorScheme == .alternate ? Color(.systemGray4) : Color(.systemGray2) }
    static var operation: Color { activeColorScheme == .alternate ? .blue : .orange }
    static var buttonBorder: Color { activeColorScheme == .alternate ? .white : .black }
    static var symbol: Color { activeColorScheme == .alternate ? .black : .white }
    
    /// Returns display color based on the orientation to fill outside
    static func edgeDisplay(for orientation: CGSize) -> Color {
        return orientation.width > orientation.height ? outside : display
    }
    
    static func toggleScheme() {
        activeColorScheme = (activeColorScheme == .default) ? .alternate : .default
    }
    
}
