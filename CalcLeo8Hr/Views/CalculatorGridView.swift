import SwiftUI

/// View for grid of calculator buttons
struct CalculatorGridView: View {
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
            Logger.debugInfo("Unknown error toggling button")
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
    
    private let overrideButtonColor: [CalculatorButton: Color] = [.standard(.clear): .yellow, .standard(.equal): .green.opacity(0.6)]
    
    private func buttonRow(rowIndex: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(buttons[rowIndex].indices, id: \.self) { columnIndex in
                let button = buttons[rowIndex][columnIndex]
                let backgroundColor = overrideButtonColor[button] ?? button.colorByType()
                
                if liveButtons[button] == true {
                    CalculatorButtonView(
                        button: button, displayValue: $displayValue,
                        backgroundColor: backgroundColor, viewModel: viewModel
                    )
                    .frame(width: buttonSize.width, height: buttonSize.height)
                }
            }
        }
    }
}
