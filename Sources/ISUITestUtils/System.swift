//
//  System.swift
//  ISUITestUtils
//
//  Created by Ivan Sorokoletov on 21/09/2019.
//  Copyright © 2019 Ivan Sorokoletov. All rights reserved.
//

import Foundation
import XCTest

public class System {
    public func wait(for seconds: TimeInterval) {
        XCTContext.runActivity(named: "Wait for : \(seconds) sec") { _ in
            let expectation = XCTNSNotificationExpectation(name: Notification.Name(rawValue: "Never notification"))
            _ = XCTWaiter.wait(for: [expectation], timeout: seconds)
        }
    }
}
