//
//  ConfigurationView.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  18CE3E7B-2370-4B69-B498-DEF58DFBC93A
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// View for sheet to configure buttons via swiches
struct ConfigurationView: View {
    @ObservedObject var configViewModel: ConfigurationViewModel
    var viewModel: CalculatorViewModel
    @Environment(\.dismiss) var dismiss
    @State var isLandscape : Bool = UIDevice.current.orientation.isLandscape
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    Spacer()
                    ScrollView {
                        ConfigurationToggleButtonView(configViewModel: configViewModel)
                            .padding()
                    }
                    .handleOrientationChange { self.isLandscape = $0 }
                    buttonSection(isLandscape: isLandscape)
                }
                .navigationTitle(LocalizedKey.buttonConfigurationSheetTitle.inUse)
            }
        }
    }
    
    private func buttonSection(isLandscape: Bool) -> some View {
        HStack {
            Spacer().opacity(isLandscape ? 1 : 0)
            resetButton()
            if isLandscape {
                Spacer()
                doneButton()
            }
            Spacer().opacity(isLandscape ? 1 : 0)
        }
    }
    
    private func doneButton() -> some View {
        Button("Done") { dismiss() }
            .padding(.vertical)
    }
    
    private func resetButton() -> some View {
        Button("Reset") { configViewModel.resetAllButtonsLive() }
            .padding(.vertical)
            .disabled(configViewModel.visibleButtons.values.allSatisfy { $0 == true })
    }
}

struct ConfigurationToggleButtonView: View {
    @ObservedObject var configViewModel: ConfigurationViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    private static let horizontalSpace: CGFloat = 36
    private static let normalSpacing: CGFloat = 16
    
    private let filteredButtons = CalculatorButton.allCases.filter { $0 != .operation(.none) }
    private var midpoint: Int {  return (1 + filteredButtons.count) / 2 }
    
    var body: some View {
        LazyVStack {
            HStack {
                ConditionalSpacer(horizontalSizeClass: horizontalSizeClass)
                LazyHStack(spacing: ConfigurationToggleButtonView.normalSpacing) {
                    ToggleStackView(buttonChoices: filteredButtons, range: 0..<midpoint, configViewModel: configViewModel)
                        .padding(.trailing, ConfigurationToggleButtonView.horizontalSpace)
                    Spacer()
                    ToggleStackView(buttonChoices: filteredButtons, range: midpoint..<filteredButtons.count, configViewModel: configViewModel)
                        .padding(.leading, ConfigurationToggleButtonView.horizontalSpace)
                }
                ConditionalSpacer(horizontalSizeClass: horizontalSizeClass)
            }
        }
    }
}

struct ConditionalSpacer: View {
    let horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        if horizontalSizeClass == .compact { Spacer(minLength: 0) }
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
