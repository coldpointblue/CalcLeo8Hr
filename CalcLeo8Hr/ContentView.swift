import SwiftUI

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

#Preview {
    ContentView(viewModel: CalculatorViewModel())
}
