//
//  CurrencyConverter.swift
//  Core
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Foundation

public enum CurrencyConverter {
    public enum ConversionError: Error {
        case rateNotFound
    }

    public static func convert(_ money: Money, to target: Currency, using rates: [ExchangeRate]) throws -> Money {
        guard money.currency != target else {
            return money
        }

        // Прямой курс из money.currency в target
        if let direct = rates.first(where: { $0.from == money.currency.rawValue && $0.to == target.rawValue }) {
            let convertedAmount = money.amount * direct.rate
            return Money(amount: convertedAmount, currency: target)
        }

        // Обратный курс из target в money.currency (делим на обратный курс)
        if let reverse = rates.first(where: { $0.from == target.rawValue && $0.to == money.currency.rawValue }) {
            let convertedAmount = money.amount / reverse.rate
            return Money(amount: convertedAmount, currency: target)
        }

        // Промежуточная конвертация через одну валюту
        for intermediate in Currency.allCases where intermediate != money.currency && intermediate != target {
            guard let toIntermediate = rates.first(where: { $0.from == money.currency.rawValue && $0.to == intermediate.rawValue }),
                  let toTarget = rates.first(where: { $0.from == intermediate.rawValue && $0.to == target.rawValue }) else {
                continue
            }

            let intermediateAmount = money.amount * toIntermediate.rate
            let finalAmount = intermediateAmount * toTarget.rate
            return Money(amount: finalAmount, currency: target)
        }

        throw ConversionError.rateNotFound
    }
}
