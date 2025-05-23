//
//  ExchangeRateModel.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

public struct ExchangeRateModel: Decodable {
    let from: String
    let to: String
    let rate: String
}
