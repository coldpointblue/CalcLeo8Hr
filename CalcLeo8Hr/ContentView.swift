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

/// Main calculator view
struct ContentView: View {
    @State private var displayValue: String = "0"
    
    var body: some View {
        GeometryReader { geometry in
            calculatorLayout(geometry: geometry)
        }
    }
    
    /// Constructs the calculator layout
    /// - Parameter geometry: GeometryProxy containing layout dimensions
    /// - Returns: A VStack containing the display and button views
    private func calculatorLayout(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            DisplayView(displayValue: $displayValue)
                .frame(height: geometry.size.height * (1/6))
                .background(CalcColor.edgeDisplay(for: geometry.size))
            
            CalculatorButtonsView(displayValue: $displayValue, geometry: (width: geometry.size.width, height: geometry.size.height * (5/6)))
        }
    }
}

/// Calculator display screen
struct DisplayView: View {
    @Binding var displayValue: String
    let numberFontSize = CGFloat(70)
    
    var body: some View {
        HStack(spacing: 0) {
            Text(displayValue)
                .font(.system(size: numberFontSize))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(CalcColor.display)
            Spacer(minLength: numberFontSize / 2)
        }
        .background(CalcColor.display)
        .padding(1)
        .border(CalcColor.display, width: 1)
    }
}

/// Grid of calculator buttons
struct CalculatorButtonsView: View {
    @Binding var displayValue: String
    var geometry: (width: CGFloat, height: CGFloat)
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .negate, .bitcoin, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.decimalPoint, .zero, .equals]
    ]
    
    // Define row and column colors as dictionaries
    private let rowColors: [Int: Color] = [0: CalcColor.utility]
    private let columnColors: [Int: Color] = [3: CalcColor.operation]
    private let overrideButtonColor: [CalculatorButton: Color] = [.equals: .orange]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(buttons.indices, id: \.self) { rowIndex in
                HStack(spacing: 0) {
                    ForEach(buttons[rowIndex].indices, id: \.self) { columnIndex in
                        let button = buttons[rowIndex][columnIndex]
                        
                        CalculatorButtonView(
                            button: button,
                            displayValue: $displayValue,
                            backgroundColor: overrideButtonColor[button] ??
                            columnColors[columnIndex] ?? rowColors[rowIndex] ??
                            CalcColor.digit
                        )
                        .frame(
                            width: geometry.width / CGFloat(buttons[rowIndex].count),
                            height: geometry.height / CGFloat(buttons.count)
                        )
                    }
                }
            }
        }
        .background(CalcColor.outside)
    }
}

/// Individual calculator button
struct CalculatorButtonView: View {
    let button: CalculatorButton
    @Binding var displayValue: String
    let backgroundColor: Color
    
    var body: some View {
        GeometryReader { geo in
            Button(action: {
                displayValue = button.rawValue
            }) {
                ZStack {
                    backgroundColor
                    Text(button.rawValue)
                        .font(.system(size: 40))
                        .foregroundColor(CalcColor.symbol)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .border(CalcColor.buttonBorder, width: 1)
        }
    }
}

#Preview {
    ContentView()
}
