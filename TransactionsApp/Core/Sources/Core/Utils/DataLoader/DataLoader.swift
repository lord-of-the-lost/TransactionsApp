//
//  DataLoader.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

public enum DataLoaderError: Error {
    case fileNotFound
    case invalidData
    case decodingError
}

public enum DataLoader {
    public static func loadTransactions() throws -> [TransactionModel] {
        try loadData(fileName: Constants.FileName.transactions)
    }
    
    public static func loadExchangeRates() throws -> [ExchangeRateModel] {
        try loadData(fileName: Constants.FileName.rates)
    }
}

// MARK: - Private Methods
private extension DataLoader {
    static func loadData<T: Decodable>(fileName: String) throws -> T {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: Constants.FileExtension.plist
        ) else {
            throw DataLoaderError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw DataLoaderError.decodingError
        }
    }
}

// MARK: - Constants
private extension DataLoader {
    enum Constants {
        enum FileExtension {
            static var plist: String { "plist" }
        }
        
        enum FileName {
            static var transactions: String { "Transactions" }
            static var rates: String { "Rates" }
        }
    }
}
