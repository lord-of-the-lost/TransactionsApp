//
//  ExchangeRate.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

public struct ExchangeRate {
    public let from: String
    public let to: String
    public let rate: Double
    
    public init?(_ model: ExchangeRateModel) {
        guard let rate = Double(model.rate) else {
            assertionFailure("Invalid rate in model: ExchangeRateModel")
            return nil
        }
        self.from = model.from
        self.to = model.to
        self.rate = rate
    }
}
