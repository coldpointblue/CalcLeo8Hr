import SwiftUI

/// Enum representing calculator button labels
enum CalculatorButton: CustomStringConvertible, Hashable {
    
    // Types of buttons
    case operation(Operation) // Note: Operation enum separate, DRY
    case standard(Standard)
    case digit(Digit)
    
    // MARK: - Nested Enums
    
    /// Enumerates standard buttons like AC, ±, etc.
    enum Standard: String, CaseIterable, Hashable {
        case clear = "AC"
        case negate = "±"
        case bitcoin = "₿"
        case decimalPoint = "."
        case equal = "="
        
        /// Returns symbol for the standard button
        var symbol: String { rawValue }
    }
    
    /// Enumerates number buttons 0-9
    enum Digit: String, CaseIterable, Hashable {
        case zero = "0", one = "1", two = "2", three = "3", four = "4",
             five = "5", six = "6", seven = "7", eight = "8", nine = "9"
        
        /// Returns symbol for the digit
        var symbol: String { rawValue }
    }
    
    // MARK: - Properties
    
    /// Returns description for specific CalculatorButton
    var description: String {
        switch self {
        case .operation(let op): return op.symbol
        case .standard(let standard): return standard.symbol
        case .digit(let digit): return digit.symbol
        }
    }
    
    /// Returns array of all possible CalculatorButtons
    static var allCases: [CalculatorButton] {
        let standardButtons = Standard.allCases.map(CalculatorButton.standard)
        let operationButtons = Operation.allCases.map(CalculatorButton.operation)
        let digitButtons = Digit.allCases.map(CalculatorButton.digit)
        
        return standardButtons + operationButtons + digitButtons
    }
    
    // MARK: - Hashable Conformance
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .operation(let operation): hasher.combine(operation)
        case .standard(let standard): hasher.combine(standard)
        case .digit(let digit): hasher.combine(digit)
        }
    }
    
    static func == (lhs: CalculatorButton, rhs: CalculatorButton) -> Bool {
        switch (lhs, rhs) {
        case (.operation(let leftOperation), .operation(let rightOperation)):
            return leftOperation == rightOperation
        case (.standard(let leftStandard), .standard(let rightStandard)):
            return leftStandard == rightStandard
        case (.digit(let leftDigit), .digit(let rightDigit)):
            return leftDigit == rightDigit
        default:
            return false
        }
    }
}

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

/// Main view for the calculator
struct ContentView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    var body: some View {
        GeometryReader { calculatorLayout(geometry: $0) }
    }
    
    private func calculatorLayout(geometry: GeometryProxy) -> some View {
        let buttonsView = CalculatorButtonsView(displayValue: $viewModel.displayValue, geometry: geometry, viewModel: viewModel)
        let totalRows = CGFloat(buttonsView.totalRows)
        let displayHeight = geometry.size.height / (totalRows + 1)  // +1 for the display row
        
        return VStack(spacing: 0) {
            DisplayView(displayValue: $viewModel.displayValue)
                .frame(height: displayHeight)
                .background(CalcColor.edgeDisplay(for: geometry.size))
            buttonsView
        }
    }
}

/// View for the calculator display screen
struct DisplayView: View {
    @Binding var displayValue: String
    let numberFontSize: CGFloat = 70
    let indentRight: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 0) {
            Text(displayValue)
                .font(.system(size: numberFontSize))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(CalcColor.display)
                .padding(.trailing, indentRight)
                .accessibilityIdentifier("displayValue") // For UI tests
        }
        .background(CalcColor.display)
        .padding(1)
        .border(CalcColor.display, width: 1)
        .minimumScaleFactor(0.5)
    }
}

/// Specific error when button is not found
enum CalculatorButtonsError: Error, CustomStringConvertible {
    case buttonNotFound(String)
    
    var description: String {
        switch self {
        case .buttonNotFound(let message):
            return "Button not in liveButtons dictionary: \(message)"
        }
    }
}

/// View for grid of calculator buttons
struct CalculatorButtonsView: View {
    @Binding var displayValue: String
    var geometry: GeometryProxy
    var viewModel: CalculatorViewModel
    
    @State private var liveButtons: [CalculatorButton: Bool] = [:]
    
    /// Keyboard reset to include every button… i.e. liveButtons[.operation(.sine)] = false
    func keyboardReset() {
        liveButtons = Dictionary(uniqueKeysWithValues: CalculatorButton.allCases.map { ($0, true) })
    }
    
    /// Toggle button to show or not… i.e. safelyToggleButton(.operation(.sine))
    func safelyToggleButton(_ button: CalculatorButton) {
        do {
            try toggleButton(button)
        } catch let error as CalculatorButtonsError {
            Logger.debugInfo(error.description)
        } catch {
            Logger.debugInfo("Uknown error toggling button")
        }
    }
    
    /// Toggle a keyboard button on/off, throws error… i.e. toggleButton(.operation(.sine))
    /// - Parameter button: The `CalculatorButton` to toggle.
    /// - Throws: An error if the button is not found.
    func toggleButton(_ button: CalculatorButton) throws {
        guard liveButtons.keys.contains(button) else {
            throw CalculatorButtonsError.buttonNotFound("Button: \(button)")
        }
        liveButtons[button] = liveButtons[button].map { !$0 }
    }
    
    // MARK: - Main Logic for Button Layout
    /// 2D layout array representing calculator buttons
    let buttons: [[CalculatorButton]] = [
        [.standard(.clear), .standard(.negate), .standard(.bitcoin), .operation(.divide)],
        [.digit(.seven), .digit(.eight), .digit(.nine), .operation(.multiply)],
        [.digit(.four), .digit(.five), .digit(.six), .operation(.subtract)],
        [.digit(.one), .digit(.two), .digit(.three), .operation(.add)],
        [.standard(.decimalPoint), .digit(.zero), .standard(.equal)],
        [.operation(.sine), .operation(.cosine)]
    ]
    
    var totalRows: Int {
        return buttons.count
    }
    
    private let rowColors: [Int: Color] = [0: CalcColor.utility]
    private let columnColors: [Int: Color] = [3: CalcColor.operation]
    private let overrideButtonColor: [CalculatorButton: Color] = [.standard(.equal): .orange]
    
    struct CalculatorUtils {
        static func responsiveButtonSize(geometry: GeometryProxy, buttons: [[CalculatorButton]]) -> CGSize {
            let totalRows = CGFloat(buttons.count) + 1
            let maxColumnCount = buttons.map { CGFloat($0.count) }.max() ?? 1
            let buttonWidth = geometry.size.width / maxColumnCount
            let buttonHeight = geometry.size.height / totalRows
            return CGSize(width: buttonWidth, height: buttonHeight)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(buttons.indices, id: \.self) { rowIndex in
                buttonRow(rowIndex: rowIndex)
            }
        }
        .background(CalcColor.outside)
        .onAppear {
            self.keyboardReset()
        }
    }
    
    private var buttonSize: CGSize {
        return CalculatorUtils.responsiveButtonSize(geometry: geometry, buttons: buttons)
    }
    
    private func buttonRow(rowIndex: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(buttons[rowIndex].indices, id: \.self) { columnIndex in
                let button = buttons[rowIndex][columnIndex]
                if liveButtons[button] == true {
                    CalculatorButtonView(
                        button: button,
                        displayValue: $displayValue,
                        backgroundColor: overrideButtonColor[button] ?? columnColors[columnIndex] ?? rowColors[rowIndex] ?? CalcColor.digit, viewModel: viewModel
                    )
                    .frame(width: buttonSize.width, height: buttonSize.height)
                }
            }
        }
    }
}

/// View for individual calculator button
struct CalculatorButtonView: View {
    let button: CalculatorButton
    @Binding var displayValue: String
    let backgroundColor: Color
    
    var viewModel: CalculatorViewModel
    
    var body: some View {
        GeometryReader { geo in
            Button(action: {
                do {
                    try viewModel.handleButtonPress(button: button)
                } catch let error as GenericError {
                    Logger.log(error.description, type: .error)
                    DispatchQueue.main.async {
                        self.displayValue = "Error"
                    }
                } catch {
                    Logger.log("An unexpected error occurred.", type: .error)
                    DispatchQueue.main.async {
                        self.displayValue = "Error"
                    }
                }
            }) {
                ZStack {
                    backgroundColor
                    Text(button.description)
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
    ContentView(viewModel: CalculatorViewModel())
}
