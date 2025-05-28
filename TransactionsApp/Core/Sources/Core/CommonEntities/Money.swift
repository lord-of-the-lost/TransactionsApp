//
//  Money.swift
//  Core
//
//  Created by Николай Игнатов on 23.05.2025.
//

import Foundation

public struct Currency: RawRepresentable, Equatable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue.uppercased()
    }

    public static let gbp = Currency(rawValue: "GBP")
    public static let usd = Currency(rawValue: "USD")
    public static let cad = Currency(rawValue: "CAD")
    public static let aud = Currency(rawValue: "AUD")
    public static let eur = Currency(rawValue: "EUR")
}

public struct Money {
    public let amount: Decimal
    public let currency: Currency

    public init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
}
