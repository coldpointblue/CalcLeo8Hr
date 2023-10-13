import SwiftUI

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
