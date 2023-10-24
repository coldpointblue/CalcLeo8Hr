import XCTest

// Note: Comprehensive unit tests are needed to cover both normal and edge cases. i.e. Tests for calculator's basic arithmetic functions, tests for when .none is passed, etc.

final class CalcLeo8HrUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddOneAndTwoIsThree() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Sequence of buttons to be tapped
        let buttonTapSequence: [CalculatorButton] = [.digit(.one),  .operation(.add), .digit(.two), .standard(.equal)]
        
        // Tap the buttons
        for button in buttonTapSequence {
            let buttonSymbol = button.description
            app.buttons[buttonSymbol].tap()
        }
        
        let displayResult = app.staticTexts["displayValue"].label
        let expectedValue = "3"
        
        XCTAssertEqual(displayResult, "3", "1 plus 2 is  \(expectedValue) but got \(displayResult)")
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
