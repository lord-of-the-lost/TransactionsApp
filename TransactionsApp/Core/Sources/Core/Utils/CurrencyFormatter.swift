//
//  CurrencyFormatter.swift
//  Core
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Foundation

/// Утилитный класс для форматирования и парсинга денежных сумм в разных валютах.
public enum CurrencyFormatter {
    
    /// Форматирует числовое значение суммы в строку с валютным символом и разделителями.
    /// - Parameters:
    ///   - amount: Сумма для форматирования.
    ///   - currency: Код валюты в формате ISO 4217 (например, "GBP", "USD").
    /// - Returns: Отформатированная строка с валютой. Если форматирование не удалось, возвращается строка вида "<currency> <amount>".
    public static func format(amount: Double, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.locale = locale(for: currency)
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: amount)) ?? "\(currency) \(amount)"
    }

    /// Универсальный метод для извлечения числового значения суммы из строки с валютой.
    /// - Parameters:
    ///   - string: Строка, содержащая сумму с символом или кодом валюты и разделителями.
    ///   - currency: Код валюты, чтобы определить символ для очистки строки.
    /// - Returns: Извлечённое числовое значение суммы или 0, если парсинг не удался.
    public static func extractAmount(from string: String, currency: String) -> Double {
        let symbol = currencySymbol(for: currency)
        let cleanedString = string
            .replacingOccurrences(of: symbol, with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return Double(cleanedString) ?? 0
    }
}

// MARK: - Private Methods
private extension CurrencyFormatter {

    /// Возвращает локаль для заданной валюты.
    static func locale(for currency: String) -> Locale {
        switch currency {
        case "GBP": return Locale(identifier: "en_GB")
        case "USD": return Locale(identifier: "en_US")
        case "CAD": return Locale(identifier: "en_CA")
        case "AUD": return Locale(identifier: "en_AU")
        default: return Locale(identifier: "en_GB")
        }
    }

    /// Возвращает символ валюты по её коду.
    /// - Parameter currency: Код валюты в формате ISO 4217.
    /// - Returns: Символ валюты, например "£" для GBP, "$" для USD и т.д.
    static func currencySymbol(for currency: String) -> String {
        switch currency {
        case "GBP": return "£"
        case "USD": return "$"
        case "CAD": return "$"
        case "AUD": return "$"
        default: return ""
        }
    }
}

