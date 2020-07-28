//
//  GTBaseModalClassUITest.swift
//  ISUITestUtils
//
//  Created by Ivan Sorokoletov on 24/07/2019.
//  Copyright © 2019 Ivan Sorokoletov. All rights reserved.
//

import XCTest

/// Base class for modal tests, which not restart app between tests: needed add app.launch to first test
class ISBaseModalClassXCUITest: XCTestCase {
    static let current = ISBaseModalClassXCUITest()
    
    // runs before all test methods
    override class func setUp() {
        super.setUp()
    }
    
    // without app.launch for modal tests
    override func setUp() {
        
        // if testCase have fail - then continue to execute all after fail (need true)
        continueAfterFailure = true
    }
    
    override func tearDown() {
        let ownScreenshot = OwnScreenshot()
        ownScreenshot.makeScreenIfTestFail()
    }
}

// MARK: - Common use functions
extension ISBaseModalClassXCUITest {
    /// App launch with replace endpoint
    func givenAppIsLaunchAt(endpointURL: String) {
        XCTContext.runActivity(named: "App launch") { _ in
            app.launchArguments.append("--REPLACEURL=\(endpointURL)")
            app.launch()
        }
    }
}
