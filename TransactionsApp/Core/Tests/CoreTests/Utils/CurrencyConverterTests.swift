//
//  CurrencyConverterTests.swift
//  CoreTests
//
//  Created by Николай Игнатов on 28.05.2025.
//

import XCTest
@testable import Core

final class CurrencyConverterTests: XCTestCase {
    func testDirectConversion() throws {
        let money = Money(amount: 100, currency: .usd)
        let model = ExchangeRateModel(from: "USD", to: "EUR", rate: "0.85")
        let exchangeRate = ExchangeRate(model)!
        let rates = [exchangeRate]
        let result = try CurrencyConverter.convert(money, to: .eur, using: rates)
        XCTAssertEqual(result.amount, 85)
        XCTAssertEqual(result.currency, .eur)
    }

    func testSameCurrencyConversion() throws {
        let money = Money(amount: 100, currency: .usd)
        let model = ExchangeRateModel(from: "USD", to: "EUR", rate: "0.85")
        let exchangeRate = ExchangeRate(model)!
        let rates = [exchangeRate]
        let result = try CurrencyConverter.convert(money, to: .usd, using: rates)
        XCTAssertEqual(result.amount, money.amount)
        XCTAssertEqual(result.currency, money.currency)
    }

    func testReverseConversion() throws {
        let money = Money(amount: 100, currency: .eur)
        let model = ExchangeRateModel(from: "USD", to: "EUR", rate: "0.85")
        let exchangeRate = ExchangeRate(model)!
        let rates = [exchangeRate]
        let result = try CurrencyConverter.convert(money, to: .usd, using: rates)
        XCTAssertEqual(result.amount, 100 / 0.85, accuracy: 0.01)
        XCTAssertEqual(result.currency, .usd)
    }

    func testIntermediateConversion() throws {
        let money = Money(amount: 100, currency: .usd)
        let model1 = ExchangeRateModel(from: "USD", to: "GBP", rate: "0.75")
        let model2 = ExchangeRateModel(from: "GBP", to: "EUR", rate: "1.15")
        let exchangeRate1 = ExchangeRate(model1)!
        let exchangeRate2 = ExchangeRate(model2)!
        let rates = [exchangeRate1, exchangeRate2]
        let result = try CurrencyConverter.convert(money, to: .eur, using: rates)
        XCTAssertEqual(result.amount, 100 * 0.75 * 1.15, accuracy: 0.01)
        XCTAssertEqual(result.currency, .eur)
    }

    func testRateNotFound() {
        let money = Money(amount: 100, currency: .usd)
        let model = ExchangeRateModel(from: "EUR", to: "GBP", rate: "0.85")
        let exchangeRate = ExchangeRate(model)!
        let rates = [exchangeRate]
        XCTAssertThrowsError(try CurrencyConverter.convert(money, to: .eur, using: rates)) { error in
            XCTAssertEqual(error as? CurrencyConverter.ConversionError, .rateNotFound)
        }
    }

    func testNoConversionPathFound() {
        let money = Money(amount: 100, currency: .usd)
        let model1 = ExchangeRateModel(from: "EUR", to: "GBP", rate: "0.85")
        let model2 = ExchangeRateModel(from: "CAD", to: "AUD", rate: "1.1")
        let exchangeRate1 = ExchangeRate(model1)!
        let exchangeRate2 = ExchangeRate(model2)!
        let rates = [exchangeRate1, exchangeRate2]
        XCTAssertThrowsError(try CurrencyConverter.convert(money, to: .eur, using: rates)) { error in
            XCTAssertEqual(error as? CurrencyConverter.ConversionError, .rateNotFound)
        }
    }
} 
