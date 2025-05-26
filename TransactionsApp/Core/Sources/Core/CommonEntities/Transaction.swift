//
//  Transaction.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

public struct Transaction {
    public let money: Money
    public let sku: String

    public init?(_ model: TransactionModel) {
        guard
            let amount = Decimal(string: model.amount)
        else {
            assertionFailure("Invalid amount in model: TransactionModel")
            return nil
        }
        let currency = Currency(rawValue: model.currency)
        self.money = Money(amount: amount, currency: currency)
        self.sku = model.sku
    }
}
