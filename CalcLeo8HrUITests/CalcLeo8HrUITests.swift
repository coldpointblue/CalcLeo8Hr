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
    
    /// Helper function to tap buttons
    private func tapButtons(_ sequence: [CalculatorButton]) {
        for button in sequence {
            let buttonSymbol = button.description
            guard app.buttons[buttonSymbol].exists else {
                XCTFail("Button \(buttonSymbol) not found")
                return
            }
            app.buttons[buttonSymbol].tap()
        }
    }
    
    /// Helper function to fetch display value
    private func fetchDisplayValue() -> String {
        if app.staticTexts["displayValue"].exists {
            return app.staticTexts["displayValue"].label
        } else {
            XCTFail("Display value not found")
            return ""
        }
    }
    
    func testAddOneAndTwoIsThree() throws {
        let buttonTapSequence: [CalculatorButton] = [.digit(.one),  .operation(.add),
                                                     .digit(.two), .standard(.equal)]
        
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
}
