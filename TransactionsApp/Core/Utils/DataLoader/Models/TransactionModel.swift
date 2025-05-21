//
//  TransactionModel.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

struct TransactionModel: Decodable {
    let amount: String
    let currency: String
    let sku: String
} 
