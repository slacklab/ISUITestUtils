//
//  Screenshots.swift
//  ISUITestUtils
//
//  Created by Ivan Sorokoletov on 02/09/2019.
//  Copyright © 2019 Ivan Sorokoletov. All rights reserved.
//

import Foundation
import XCTest

public class OwnScreenshot: XCTestCase {
    public let sys = System()
    
    public func make(nameWhatMustBe: String, waitFor: XCUIElement, waitForSec: TimeInterval = 2) {
        _ = waitFor.waitForExistence(timeout: waitForSec)
        
        XCTContext.runActivity(named: nameWhatMustBe) { (activity) in
            let screen = XCUIScreen.main
            let fullscreenshot = screen.screenshot()
            let fullScreenshotAttachment = XCTAttachment(screenshot: fullscreenshot)
            fullScreenshotAttachment.name = "OwnScreen" + " - " + nameWhatMustBe
            fullScreenshotAttachment.lifetime = .keepAlways
            activity.add(fullScreenshotAttachment)
        }
    }
    
    public func makeWithSleep(nameWhatMustBe: String, sleepInSec: TimeInterval = 0.5) {
        sys.wait(for: sleepInSec)
        
        XCTContext.runActivity(named: nameWhatMustBe) { (activity) in
            let screen = XCUIScreen.main
            let fullscreenshot = screen.screenshot()
            let fullScreenshotAttachment = XCTAttachment(screenshot: fullscreenshot)
            fullScreenshotAttachment.name = "OwnScreen" + " - " + nameWhatMustBe
            fullScreenshotAttachment.lifetime = .keepAlways
            activity.add(fullScreenshotAttachment)
        }
    }
    
    // Make screenshot in a moment when test fail
    public func makeScreenIfTestFail() {
        if let failureCount = testRun?.failureCount, failureCount > 0 {
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways
            attachment.name = "TestFail"
            add(attachment)
        }
    }
}
