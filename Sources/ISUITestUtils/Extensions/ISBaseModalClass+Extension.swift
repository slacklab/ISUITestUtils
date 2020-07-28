//
//  GTBaseModalClass+Extension.swift
//  ISUITestUtils
//
//  Created by Ivan Sorokoletov on 02/09/2019.
//  Copyright © 2019 Ivan Sorokoletov. All rights reserved.
//

import Foundation
import XCTest

extension ISBaseModalClassXCUITest {
    
    enum TimeOut: TimeInterval {
        case none = 0
        case mid = 3
        case long = 6
        case superLong = 9
        case overLong = 15
    }
    
    /// Make screenshot what you want to see at this step
    ///
    /// - Parameters:
    ///   - see: name of screen what you should to see
    ///   - waitFor: wait for this element for existance
    public func thenWillLegacy(_ see: String, waitFor: XCUIElement, sec: TimeOut = .none) {
        let ownScreenshot = OwnScreenshot()
        _ = waitFor.waitForExistence(timeout: sec.rawValue)
        
        ownScreenshot.make(nameWhatMustBe: "SCREEN: " + see, waitFor: waitFor)
    }
    
    public func thenWillNew(_ see: String, isLoadScreen: Bool) {
        let ownScreenshot = OwnScreenshot()
        
        switch isLoadScreen {
        case true:
            ownScreenshot.makeWithSleep(nameWhatMustBe: "SCREEN: " + see, sleepInSec: 0)
        case false:
            ownScreenshot.makeWithSleep(nameWhatMustBe: "SCREEN: " + see, sleepInSec: 0)
            XCTFail("SCREEN is not load")
        }
    }
    
    /// Make screenshot when we cannot know what see on this
    /// and sleep for some time
    public func thenWill(_ see: String) {
        let ownScreenshot = OwnScreenshot()
        
        ownScreenshot.makeWithSleep(nameWhatMustBe: "SCREEN: " + see)
    }
    
    /// Make only line at report with description
    /// - Parameter lineAtReport: This will be dispayd as step at report
    public func thenLog(_ lineAtReport: String) {
        XCTContext.runActivity(named: "LOG: " + lineAtReport) { _ in
            
        }
    }
    
    public func customAssert(someExpression: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(someExpression, file: file, line: line)
    }
    
    public func waitMainElement(which: XCUIElement, second: TimeInterval) -> Bool {
        XCTContext.runActivity(named: "Wait main element: \(which)") { _ in
            let isLoadScreen = which.ownExists(waitForSec: second)
            
            if isLoadScreen {
                return true
            } else {
                return false
            }
        }
    }
    
    public func dismissKeyboard() {
        XCTContext.runActivity(named: "Dismiss keyboard by swipe") { _ in
            app.swipeDown()
        }
    }
}
