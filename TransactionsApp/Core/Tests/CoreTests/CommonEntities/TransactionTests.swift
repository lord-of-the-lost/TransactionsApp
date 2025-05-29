//
//  TransactionTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 28.05.2025.
//

import XCTest
@testable import Core

final class TransactionTests: XCTestCase {
    func testTransactionInitialization() {
        let model = TransactionModel(amount: "100", currency: "USD", sku: "SKU123")
        let transaction = Transaction(model)
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction?.money.amount, 100)
        XCTAssertEqual(transaction?.money.currency, .usd)
        XCTAssertEqual(transaction?.sku, "SKU123")
    }

    func testInvalidAmountInitialization() {
        let model = TransactionModel(amount: "invalid", currency: "USD", sku: "SKU123")
        let transaction = Transaction(model)
        XCTAssertNil(transaction)
    }
} 
