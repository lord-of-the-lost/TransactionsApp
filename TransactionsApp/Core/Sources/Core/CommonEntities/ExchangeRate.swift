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
    public let rate: Decimal
    
    public init?(_ model: ExchangeRateModel) {
        guard let decimalRate = Decimal(string: model.rate) else {
            return nil
        }
        self.from = model.from
        self.to = model.to
        self.rate = decimalRate
    }
}
