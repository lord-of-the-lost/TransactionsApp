//
//  SignedNumericExtensionTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 29.05.2025.
//

import XCTest
@testable import Core

final class SignedNumericExtensionTests: XCTestCase {
    func testNegative() {
        let number: Int = 5
        XCTAssertEqual(number.negative, -5)
    }
} 
