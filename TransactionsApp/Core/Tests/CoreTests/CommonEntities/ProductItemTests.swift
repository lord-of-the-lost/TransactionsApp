//
//  ProductItemTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 29.05.2025.
//

import XCTest
@testable import Core

final class ProductItemTests: XCTestCase {
    func testProductItemInitialization() {
        let sku = "SKU123"
        let transactions = [Transaction(TransactionModel(amount: "100", currency: "USD", sku: sku))!]
        let productItem = ProductItem(sku: sku, transactions: transactions)
        XCTAssertEqual(productItem.sku, sku)
        XCTAssertEqual(productItem.transactions.count, 1)
        XCTAssertEqual(productItem.transactions.first?.sku, sku)
    }
} 
