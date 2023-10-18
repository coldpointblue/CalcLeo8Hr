import SwiftUI

/// View for individual calculator button
struct CalculatorButtonView: View {
    let button: CalculatorButton
    @Binding var displayValue: String
    let backgroundColor: Color
    
    var viewModel: CalculatorViewModel
    
    var body: some View {
        GeometryReader { geo in
            Button(action: handleButtonPress) {
                ZStack {
                    backgroundColor
                    Text(button.description)
                        .modifier(CalculatorButtonViewStyle())
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .border(CalcColor.buttonBorder, width: 1)
        }
    }
    
    func handleButtonPress() {
        do {
            try viewModel.handleButtonPress(button: button)
        } catch let error {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        Logger.log("An unexpected error occurred pressing button: \(error.localizedDescription)", type: .error)
        DispatchQueue.main.async {
            self.displayValue = "Error"
        }
    }
}

struct CalculatorButtonViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 40))
            .foregroundColor(CalcColor.symbol)
    }
}
