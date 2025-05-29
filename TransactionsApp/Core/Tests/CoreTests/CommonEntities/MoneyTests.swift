//
//  MoneyTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 28.05.2025.
//

import XCTest
@testable import Core

final class MoneyTests: XCTestCase {
    func testMoneyInitialization() {
        let money = Money(amount: 100, currency: .usd)
        XCTAssertEqual(money.amount, 100)
        XCTAssertEqual(money.currency, .usd)
    }

    func testCurrencyEquality() {
        let currency1 = Currency(rawValue: "USD")
        let currency2 = Currency(rawValue: "usd")
        XCTAssertEqual(currency1, currency2)
    }
} 
