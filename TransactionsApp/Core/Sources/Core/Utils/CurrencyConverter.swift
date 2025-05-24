//
//  CurrencyConverter.swift
//  Core
//
//  Created by Николай Игнатов on 22.05.2025.
//

public enum CurrencyConverter {
    public enum ConversionError: Error {
        case rateNotFound
    }

    public static func convert(_ money: Money, to target: Currency, using rates: [ExchangeRate]) throws -> Money {
        guard money.currency != target else {
            return money
        }

        // 1. Прямой курс
        if let direct = rates.first(where: { $0.from == money.currency.rawValue && $0.to == target.rawValue }) {
            return Money(amount: money.amount * direct.rate, currency: target)
        }

        // 2. Обратный курс
        if let reverse = rates.first(where: { $0.from == target.rawValue && $0.to == money.currency.rawValue }) {
            return Money(amount: money.amount / reverse.rate, currency: target)
        }

        // 3. Пробуем найти промежуточную валюту через 1 шаг
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
