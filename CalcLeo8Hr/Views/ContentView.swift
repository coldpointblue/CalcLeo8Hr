import SwiftUI

/// Main view for the calculator
struct ContentView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    let configVM : ConfigurationViewModel = ConfigurationViewModel.shared
    
    @State private var isErrorShown: Bool = false
    @State private var isConfigurationShown: Bool = false
    private static let longPressDurationSecs: Double = 1.0
    
    var body: some View {
        GeometryReader { calculatorLayout(geometry: $0) }
            .alert(isPresented: $isErrorShown) {
                alertSpecifics()
            }
    }
    
    private func calculatorLayout(geometry: GeometryProxy) -> some View {
        let buttonsView = CalculatorGridView(displayValue: $viewModel.displayValue, geometry: geometry, viewModel: viewModel)
        let totalRows = CGFloat(buttonsView.totalRows)
        let displayHeight = geometry.size.height / (totalRows + 1)  // +1 for the display row
        
        return VStack(spacing: 0) {
            DisplayView(displayValue: $viewModel.displayValue)
                .frame(height: displayHeight)
                .background(CalcColor.edgeDisplay(for: geometry.size))
                .onLongPressGesture(minimumDuration: ContentView.longPressDurationSecs) {
                    isConfigurationShown.toggle()
                }
            buttonsView
        }
        .sheet(isPresented: $isConfigurationShown) {
            ConfigurationView(configViewModel: configVM, viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView(viewModel: CalculatorViewModel())
}
