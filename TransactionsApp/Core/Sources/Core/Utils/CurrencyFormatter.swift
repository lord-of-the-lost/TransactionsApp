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
    
    private static let localeIdentifier = Locale(identifier: LocaleIdentifier.us.rawValue)
    
    public static func format(_ money: Money) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = money.currency.rawValue
        formatter.locale = localeIdentifier
        formatter.usesGroupingSeparator = true

        return formatter.string(from: money.amount as NSDecimalNumber) ?? "\(money.currency.rawValue) \(money.amount)"
    }

    public static func extractAmount(from string: String, currency: Currency) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        formatter.locale = localeIdentifier
        return formatter.number(from: string)?.decimalValue
    }
}
