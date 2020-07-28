//
//  XCUIElement+Extension.swift
//  ISUITestUtilsUITests
//
//  Created by Ivan Sorokoletov on 01/09/2019.
//  Copyright © 2019 Ivan Sorokoletov. All rights reserved.
//

import Foundation
import XCTest

// MARK: - Taps
extension XCUIElement {
    public func ownWaitTap(waitForSecond: TimeInterval) {
        _ = waitForExistence(timeout: waitForSecond)
        tap()
    }
    
    public func ownWaitAssertTap(waitForSecond: TimeInterval) {
        _ = waitForExistence(timeout: waitForSecond)
        XCTAssert(exists)
        tap()
    }
    
    /// Tap when isAccessibilityElement property is false
    public func ownForceTap() {
        if isHittable {
            tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}

// MARK: - Exists
extension XCUIElement {
    /// More safe  than system exists - wait some time for exists
    public func ownExists(waitForSec: TimeInterval = 1) -> Bool {
        _ = waitForExistence(timeout: waitForSec)
        
        if exists {
            return true
        } else {
            return false
        }
    }
    
    public func ownExistsAssert(waitForSec: TimeInterval = 1) -> Bool {
        _ = waitForExistence(timeout: waitForSec)
        
        if exists {
            XCTAssert(true, "\(#function) \(self) Exists")
            
            return true
        } else {
            XCTAssert(false, "\(#function) \(self) Not exists")
            
            return false
        }
    }
    
    /// Check element: wait,  exist and isHittable, tap
    public func ownWaitExistsHit(waitForSec: TimeInterval) -> Bool {
        _ = waitForExistence(timeout: waitForSec)
                
        if exists && isHittable{
                return true
        } else {
            return false
        }
    }
}

// MARK: - Type text

extension XCUIElement {
    public func ownTapType(text: String, waitForSec: TimeInterval) {
        _ = waitForExistence(timeout: waitForSec)
        
        tap()
        
        System().wait(for: 1)
        
        typeText(text)
    }
}

extension XCUIElement {
    /// Remove text from textfield and enter new
    /// - Parameter text: what to input after clearing
    public func ownClearInputText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        
        typeText(deleteString)
        typeText(text)
    }
}

// MARK: - Access to element
extension XCUIElement {
    /// Return needed element by index from many sameless elements.
    /// Used ready function from Parent/GetTransferUITest.swift
    /// - Parameters:
    ///   - query: from many elements , example: app.textFields
    ///   - accessibility: example: "searchTextField" (String)
    ///   - index: Int index (start from 0)
    /// - Returns: return needed XCUIElement by index
    public func elementAtIndex(in query: XCUIElementQuery, accessibility: String, at index: Int) -> XCUIElement? {
        let elements = query.allElementsBoundByAccessibilityElement
        var current = 0
        
        for element in elements where element.label == accessibility {
            if current == index {
                return element
            }
            current += 1
        }
        return nil
    }
}

// MARK: - Switchers

extension XCUIElement {
    public func setSwitcherTo(status: Bool) {
        let on = "1"
        let off = "0"
        
        XCTContext.runActivity(named: "Set \(self) switcher to: \(status)") { _ in
            switch status {
            case true:
                if value as? String == off {
                    ownWaitTap(waitForSecond: 0)
                }
            case false:
                if value as? String == on {
                    ownWaitTap(waitForSecond: 0)
                }
            }
        }
    }
    
    public func checkSwitcherMustBe(status: Bool) {
        let on = "1"
        let off = "0"
        
        let realState = value as? String
        
        let report = "Check \(self) switcher must be: \(status) "
        
        XCTContext.runActivity(named: report) { _ in
            switch status {
            case true:
                XCTAssertTrue(realState == on, report + "but equal: \(realState ?? "...")")
            case false:
                XCTAssertTrue(realState == off, report + "but equal: \(realState ?? "...")")
            }
        }
    }
}

// MARK: - Swipes
extension XCUIElement {
    public enum Direction : Int {
        case up, down, left, right
    }
    
    public func gentleSwipe(_ direction : Direction) {
        let half : CGFloat = 0.5

        let adjustment : CGFloat = 0.25

        let pressDuration : TimeInterval = 0.05
        
        let lessThanHalf = half - adjustment
        let moreThanHalf = half + adjustment
        
        let centre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: half))
        let aboveCentre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: lessThanHalf))
        let belowCentre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: moreThanHalf))
        let leftOfCentre = coordinate(withNormalizedOffset: CGVector(dx: lessThanHalf, dy: half))
        let rightOfCentre = coordinate(withNormalizedOffset: CGVector(dx: moreThanHalf, dy: half))
        
        switch direction {
        case .up:
            centre.press(forDuration: pressDuration, thenDragTo: aboveCentre)
        case .down:
            centre.press(forDuration: pressDuration, thenDragTo: belowCentre)
        case .left:
            centre.press(forDuration: pressDuration, thenDragTo: leftOfCentre)
        case .right:
            centre.press(forDuration: pressDuration, thenDragTo: rightOfCentre)
        }
    }
    
    
    /// Gentle swipe to element
    /// Example: app.swipeUpTo(to: element)
    public func swipeUp(to element: XCUIElement) {
        while !(elementIsWithinWindow(element: element)) {
            app.gentleSwipe(.up)
        }
    }
    
    /// Helper func for swipe to element
    public func elementIsWithinWindow(element: XCUIElement) -> Bool{
        guard element.exists && element.isHittable else {return false}
        return true
    }
}
