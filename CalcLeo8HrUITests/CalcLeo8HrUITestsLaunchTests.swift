//  ----------------------------------------------------
//
//  CalcLeo8HrUITestsLaunchTests.swift
//  Version 1.0
//
//  Unique ID:  BDE94CC3-C241-48AB-9C8D-FC220BC84F2B
//
//  part of the CalcLeo8HrUITests™ product.
//
//  Written in Swift 5.0 on macOS 14.0
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2023-10-11.
//  
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  (whole app does? … for users)   */
//  ----------------------------------------------------


import XCTest

final class CalcLeo8HrUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
