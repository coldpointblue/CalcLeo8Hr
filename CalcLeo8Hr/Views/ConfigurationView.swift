import SwiftUI

/// View for sheet to configure buttons via swiches
struct ConfigurationView: View {
    @ObservedObject var configViewModel: ConfigurationViewModel
    var viewModel: CalculatorViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ScrollView {
                    ConfigurationToggleButtonView(configViewModel: configViewModel)
                        .padding()
                }
                Button("Reset") {
                    configViewModel.resetAllButtonsLive()
                }
                .padding(.vertical)
            }
            .navigationTitle(LocalizedKey.buttonConfigurationSheetTitle.inUse)
        }
    }
}

struct ConfigurationToggleButtonView: View {
    @ObservedObject var configViewModel: ConfigurationViewModel
    private static let horizontalSpace: CGFloat = 36
    private static let normalSpacing: CGFloat = 16
    
    var body: some View {
        let filteredButtons = CalculatorButton.allCases.filter { $0 != .operation(.none) }
        let midpoint = (1 + filteredButtons.count) / 2
        
        return LazyHStack(spacing: ConfigurationToggleButtonView.normalSpacing) {
            ToggleStackView(buttonChoices: filteredButtons, range: 0..<midpoint, configViewModel: configViewModel)
                .padding(.trailing, ConfigurationToggleButtonView.horizontalSpace)
            Spacer()
            ToggleStackView(buttonChoices: filteredButtons, range: midpoint..<filteredButtons.count, configViewModel: configViewModel)
                .padding(.leading, ConfigurationToggleButtonView.horizontalSpace)
        }
    }
}

struct ToggleStackView: View {
    let buttonChoices: [CalculatorButton]
    let range: Range<Int>
    @ObservedObject var configViewModel: ConfigurationViewModel
    private static let normalSpacing: CGFloat = 16
    
    var body: some View {
        let validRange = range.clamped(to: 0..<buttonChoices.count)
        
        return VStack(spacing: ToggleStackView.normalSpacing) {
            ForEach(validRange, id: \.self) { index in
                let button = buttonChoices[index]
                if let _ = configViewModel.visibleButtons[button] {
                    Toggle("\(String(describing: button))", isOn: Binding(
                        get: { self.configViewModel.visibleButtons[button] ?? false },
                        set: { self.configViewModel.visibleButtons[button] = $0 }
                    ))
                }
            }
        }
        .padding(.vertical, 3 * ToggleStackView.normalSpacing)
    }
}
