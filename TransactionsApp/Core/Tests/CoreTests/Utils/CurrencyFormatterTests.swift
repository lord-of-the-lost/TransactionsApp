//
//  CurrencyFormatterTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 29.05.2025.
//

import XCTest
@testable import Core

final class CurrencyFormatterTests: XCTestCase {
    func testFormatMoney() {
        let money = Money(amount: 100, currency: .usd)
        let formatted = CurrencyFormatter.format(money)
        XCTAssertEqual(formatted, "$100.00")
    }

    func testExtractAmount() {
        let string = "$100.00"
        let amount = CurrencyFormatter.extractAmount(from: string, currency: .usd)
        XCTAssertEqual(amount, 100)
    }

    func testExtractAmountWithInvalidString() {
        let string = "invalid"
        let amount = CurrencyFormatter.extractAmount(from: string, currency: .usd)
        XCTAssertNil(amount)
    }
} 
