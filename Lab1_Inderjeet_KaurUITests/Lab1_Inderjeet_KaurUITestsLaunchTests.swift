//
//  Lab1_Inderjeet_KaurUITestsLaunchTests.swift
//  Lab1_Inderjeet_KaurUITests
//
//  Created by Inderjeet Kaur on 2025-02-13.
//

import XCTest

final class Lab1_Inderjeet_KaurUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
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
