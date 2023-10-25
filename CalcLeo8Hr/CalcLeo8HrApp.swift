//
//  CalcLeo8HrApp.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  E42D018A-4C44-47C9-A5B4-5A73472F1AA7
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

@main
struct CalcLeo8HrApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: CalculatorViewModel())
        }
    }
}
