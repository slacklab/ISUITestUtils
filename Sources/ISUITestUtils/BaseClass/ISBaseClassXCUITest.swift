//
//  ISBaseClassXCUITest.swift
//  ISUITestUtils
//
//  Created by Ivan Sorokoletov on 05/07/2019.
//  Copyright © 2019 Ivan Sorokoletov. All rights reserved.
//

import XCTest

let app = XCUIApplication()

public class ISBaseClassXCUITest: XCTestCase {
        
    public override func setUp() {
        continueAfterFailure = false
                    
        app.launch()
    }
    
    public override func tearDown() {
       let ownScreenshot = OwnScreenshot()

        ownScreenshot.makeScreenIfTestFail()
    }
}
