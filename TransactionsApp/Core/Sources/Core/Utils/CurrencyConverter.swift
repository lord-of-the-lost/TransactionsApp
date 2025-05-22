//
//  CurrencyConverter.swift
//  Core
//
//  Created by Николай Игнатов on 22.05.2025.
//

/// Утилита для конвертации сумм из произвольной валюты в GBP с использованием списка обменных курсов.
public enum CurrencyConverter {

    /// Конвертирует сумму из указанной валюты в GBP.
    ///
    /// Алгоритм:
    /// - Если валюта уже GBP, возвращается исходная сумма.
    /// - Пытается найти прямой курс конвертации из `currency` в GBP.
    /// - Если прямого курса нет, пытается найти обратный курс из GBP в `currency` и делит сумму на него.
    /// - Если оба варианта не найдены, рекурсивно пытается конвертировать через промежуточные валюты.
    /// - Если конвертация невозможна, возвращает 0.
    ///
    /// - Parameters:
    ///   - amount: Сумма в исходной валюте.
    ///   - currency: Код исходной валюты (ISO 4217).
    ///   - rates: Массив доступных обменных курсов.
    /// - Returns: Конвертированная сумма в GBP, или 0 при невозможности конвертации.
    public static func convertToGBP(amount: Double, currency: String, rates: [ExchangeRate]) -> Double {
        guard currency != "GBP" else { return amount }
        
        if let directRate = findDirectRate(from: currency, to: "GBP", rates: rates) {
            return amount * directRate.rate
        }
        
        if let reverseRate = findDirectRate(from: "GBP", to: currency, rates: rates) {
            return amount / reverseRate.rate
        }
        
        return convertViaIntermediate(amount: amount, from: currency, rates: rates)
    }
}

// MARK: - Private Methods
private extension CurrencyConverter {
    /// Находит прямой обменный курс из одной валюты в другую.
    private static func findDirectRate(from: String, to: String, rates: [ExchangeRate]) -> ExchangeRate? {
        rates.first(where: { $0.from == from && $0.to == to })
    }
    
    /// Пытается рекурсивно конвертировать сумму в GBP через промежуточные валюты.
    ///
    /// - Parameters:
    ///   - amount: Сумма в исходной валюте.
    ///   - from: Код исходной валюты.
    ///   - rates: Массив доступных обменных курсов.
    /// - Returns: Конвертированная сумма в GBP, либо 0, если конвертация невозможна.
    private static func convertViaIntermediate(amount: Double, from: String, rates: [ExchangeRate]) -> Double {
        for rate in rates where rate.from == from {
            let convertedAmount = amount * rate.rate
            let result = convertToGBP(amount: convertedAmount, currency: rate.to, rates: rates)
            if result > 0 {
                return result
            }
        }
        return 0
    }
}
