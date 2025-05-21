//
//  Transaction.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

struct Transaction {
    let amount: Double
    let currency: String
    let sku: String
    
    init?(_ model: TransactionModel) {
        guard let amount = Double(model.amount) else {
            assertionFailure("Invalid amount in model: TransactionModel")
            return nil
        }
        self.amount = amount
        self.currency = model.currency
        self.sku = model.sku
    }
}
