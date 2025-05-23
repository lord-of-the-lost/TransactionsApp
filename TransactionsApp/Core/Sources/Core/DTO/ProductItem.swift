//
//  ProductItem.swift
//  Core
//
//  Created by Николай Игнатов on 23.05.2025.
//

public struct ProductItem {
    public let sku: String
    public let transactions: [Transaction]
    
    public init(sku: String, transactions: [Transaction]) {
        self.sku = sku
        self.transactions = transactions
    }
}
