import SwiftUI

/// View for sheet to configure buttons via swiches
struct ConfigurationView: View {
    @State private var visibleButtons: [Bool] = Array(repeating: true, count: CalculatorButton.allCases.count)
    
    var body: some View {
        NavigationView {
            ScrollView {
                ConfigurationToggleButtonView(visibleButtons: $visibleButtons)
                    .padding()
            }
            .navigationTitle(LocalizedKey.buttonConfigurationSheetTitle.inUse)
        }
    }
}

struct ConfigurationToggleButtonView: View {
    @Binding var visibleButtons: [Bool]
    
    var body: some View {
        let filteredButtons = CalculatorButton.allCases.filter { $0 != .operation(.none) }
        let midpoint = 1 + filteredButtons.count / 2
        
        return LazyHStack(spacing: 16) {
            ToggleStackView(buttonChoices: filteredButtons, range: 0..<midpoint, visibleButtonSwitches: $visibleButtons)
                .padding(.trailing, 36)
            
            ToggleStackView(buttonChoices: filteredButtons, range: midpoint..<filteredButtons.count, visibleButtonSwitches: $visibleButtons)
                .padding(.leading, 36)
        }
    }
}

struct ToggleStackView: View {
    let buttonChoices: [CalculatorButton]
    let range: Range<Int>
    @Binding var visibleButtonSwitches: [Bool]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(range, id: \.self) { index in
                if index >= 0 && index < visibleButtonSwitches.count {
                    Toggle("\(String(describing: buttonChoices[index]))", isOn: $visibleButtonSwitches[index])
                } else {
                    EmptyView()
                        .onAppear {
                            Logger.log("Index \(index) is out of range for switchStates array.", type: .warning)
                        }
                }
            }
        }
        .padding(.vertical, 52)
    }
}
