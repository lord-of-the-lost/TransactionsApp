//
//  Money.swift
//  Core
//
//  Created by Николай Игнатов on 23.05.2025.
//

import Foundation

public enum Currency: String, CaseIterable {
    case gbp = "GBP"
    case usd = "USD"
    case cad = "CAD"
    case aud = "AUD"
}

public struct Money {
    public let amount: Decimal
    public let currency: Currency

    public init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
}
