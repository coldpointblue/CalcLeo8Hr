//
//  ContentView.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  2F3BE284-96B5-49BB-9143-E494115EB0CC
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

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
