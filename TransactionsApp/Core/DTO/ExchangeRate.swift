//
//  ExchangeRate.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

struct ExchangeRate {
    let from: String
    let to: String
    let rate: Double
    
    init?(_ model: ExchangeRateModel) {
        guard let rate = Double(model.rate) else {
            assertionFailure("Invalid rate in model: ExchangeRateModel")
            return nil
        }
        self.from = model.from
        self.to = model.to
        self.rate = rate
    }
}
