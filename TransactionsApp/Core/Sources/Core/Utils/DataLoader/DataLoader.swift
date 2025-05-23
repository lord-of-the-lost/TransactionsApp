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
    public static func loadTransactions(completion: @escaping (Result<[TransactionModel], DataLoaderError>) -> Void) {
        loadPlistData(file: Constants.FileName.transactions, completion: completion)
    }
    
    public static func loadExchangeRates(completion: @escaping (Result<[ExchangeRateModel], DataLoaderError>) -> Void) {
        loadPlistData(file: Constants.FileName.rates, completion: completion)
    }
}

// MARK: - Private Methods
private extension DataLoader {
    static func loadPlistData<T: Decodable>(
        file name: String,
        completion: @escaping (Result<T, DataLoaderError>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result: Result<T, DataLoaderError> = {
                guard let url = Bundle.main.url(forResource: name, withExtension: Constants.FileExtension.plist) else {
                    return .failure(.fileNotFound)
                }
                do {
                    let data = try Data(contentsOf: url)
                    let model = try PropertyListDecoder().decode(T.self, from: data)
                    return .success(model)
                } catch {
                    return .failure(.decodingError)
                }
            }()
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}


// MARK: - Constants
private extension DataLoader {
    enum Constants {
        enum FileExtension {
            static let plist: String = "plist"
        }
        
        enum FileName {
            static let transactions: String = "Transactions"
            static let rates: String = "Rates"
        }
    }
}
