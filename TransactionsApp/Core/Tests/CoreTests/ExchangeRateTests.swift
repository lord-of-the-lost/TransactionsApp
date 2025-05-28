//
//  ExchangeRateTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 28.05.2025.
//

import XCTest
@testable import Core

final class ExchangeRateTests: XCTestCase {
    func testExchangeRateInitialization() {
        let model = ExchangeRateModel(from: "USD", to: "EUR", rate: "0.85")
        let exchangeRate = ExchangeRate(model)
        XCTAssertNotNil(exchangeRate)
        XCTAssertEqual(exchangeRate?.from, "USD")
        XCTAssertEqual(exchangeRate?.to, "EUR")
        XCTAssertEqual(exchangeRate?.rate, 0.85)
    }

    func testInvalidRateInitialization() {
        let model = ExchangeRateModel(from: "USD", to: "EUR", rate: "invalid")
        let exchangeRate = ExchangeRate(model)
        XCTAssertNil(exchangeRate)
    }
}
