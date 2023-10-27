//
//  CalcLeo8HrUITests.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  D0615106-CDBF-4358-BC91-E34F55FB0D6B
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import XCTest

// Note: Comprehensive unit tests are needed to cover both normal and edge cases. i.e. Tests for calculator's basic arithmetic functions, tests for when .none is passed, etc.

final class CalcLeo8HrUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .landscapeLeft
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddOneAndTwoIsThree() throws {
        let buttonTapSequence: [CalculatorButton] = [.digit(.one),
                                                     .operation(.add),
                                                     .digit(.two),
                                                     .standard(.equal)]
        
        tapButtons(buttonTapSequence)
        let displayResult = fetchDisplayValue()
        let expectedValue = "3"
        
        XCTAssertEqual(displayResult, expectedValue, "1 plus 2 is \(expectedValue) but got \(displayResult)")
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Helper function to tap buttons.
    /// - Parameter sequence: A list of `CalculatorButton` that need to be tapped.
    private func tapButtons(_ sequence: [CalculatorButton]) {
        sequence.forEach { button in
            let buttonSymbol: String = button.description
            guard app.buttons[buttonSymbol].exists else {
                XCTFail("Button \(buttonSymbol) not found")
                return
            }
            app.buttons[buttonSymbol].tap()
        }
    }
    
    /// Helper function to fetch display value from UI.
    /// - Returns: The displayed string value.
    private func fetchDisplayValue() -> String {
        if app.staticTexts["displayValue"].exists {
            return app.staticTexts["displayValue"].firstMatch.label
        } else {
            XCTFail("Display value not found")
            return ""
        }
    }
}
