//
//  CurrencyFormatter.swift
//  Core
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Foundation

public enum CurrencyFormatter {
    public enum LocaleIdentifier: String {
        case us = "en_US"
    }
    
    private static let lock = NSLock()

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: LocaleIdentifier.us.rawValue)
        return formatter
    }()

    public static func format(_ money: Money) -> String {
        lock.lock()
        defer { lock.unlock() }

        formatter.currencyCode = money.currency.rawValue
        return formatter.string(from: money.amount as NSDecimalNumber)
            ?? "\(money.currency.rawValue) \(money.amount)"
    }

    public static func extractAmount(from string: String, currency: Currency) -> Decimal? {
        lock.lock()
        defer { lock.unlock() }

        formatter.currencyCode = currency.rawValue
        return formatter.number(from: string)?.decimalValue
    }
}

