//
//  ArrayExtensionTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 29.05.2025.
//

import XCTest
@testable import Core

final class ArrayExtensionTests: XCTestCase {
    func testSafeSubscript() {
        let array = [1, 2, 3]
        XCTAssertEqual(array[safe: 0], 1)
        XCTAssertEqual(array[safe: 2], 3)
        XCTAssertNil(array[safe: 3])
    }
} 
