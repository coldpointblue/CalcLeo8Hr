//
//  CalculatorGridView.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  AADB704C-0502-4569-AC5D-387A71B8128B
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// View for grid of calculator buttons
struct CalculatorGridView: View {
    @Binding var displayValue: String
    var geometry: GeometryProxy
    @ObservedObject var viewModel: CalculatorViewModel
    @ObservedObject var configVM: ConfigurationViewModel = ConfigurationViewModel.shared
    
    var visibleButtons: [CalculatorButton: Bool] {
        return configVM.visibleButtons
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
        LazyVStack(spacing: 0) {
            ForEach(buttons.indices, id: \.self) { rowIndex in
                buttonRow(rowIndex: rowIndex)
            }
        }
        .background(CalcColor.outside)
        .onAppear {
            configVM.resetAllButtonsLive()
        }
    }
    
    var buttonSize: CGSize {
        return CalculatorUtils.responsiveButtonSize(geometry: geometry, buttons: buttons)
    }
    
    let overrideButtonColor: [CalculatorButton: Color] = [.standard(.clear): .yellow, .standard(.equal): .green.opacity(0.6)]
    
    func buttonRow(rowIndex: Int) -> some View {
        LazyHStack(spacing: 0) {
            ForEach(buttons[rowIndex].indices, id: \.self) { columnIndex in
                let button = buttons[rowIndex][columnIndex]
                let backgroundColor = overrideButtonColor[button] ?? button.colorByType()
                
                if visibleButtons[button] == true {
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
