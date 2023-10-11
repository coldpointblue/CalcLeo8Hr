import SwiftUI

/// Calculator button labels
enum CalculatorButton: String, CaseIterable {
    case clear = "AC", negate = "±", bitcoin = "₿",  divide = "÷"
    case seven = "7", eight = "8", nine = "9", multiply = "×"
    case four = "4", five = "5", six = "6", subtract = "-"
    case one = "1", two = "2", three = "3", add = "+"
    case zero = "0", decimalPoint = ".", equals = "="
}

/// Color scheme for calculator
struct CalcColor {
    static let display: Color = .white
    static let outside: Color = .black
    static let utility: Color = Color(.systemGray)
    static let digit: Color = Color(.systemGray2)
    static let operation: Color = .orange
    static let buttonBorder: Color = .black
    static let symbol: Color = .white
    
    static func edgeDisplay(for orientation: CGSize) -> Color {
        orientation.width > orientation.height ? outside : display
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
