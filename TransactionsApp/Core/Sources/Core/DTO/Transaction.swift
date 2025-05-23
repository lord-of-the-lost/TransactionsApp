//
//  Transaction.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

public struct Transaction {
    public let amount: Double
    public let currency: String
    public let sku: String
    
    public init?(_ model: TransactionModel) {
        guard let amount = Double(model.amount) else {
            assertionFailure("Invalid amount in model: TransactionModel")
            return nil
        }
        self.amount = amount
        self.currency = model.currency
        self.sku = model.sku
    }
}
