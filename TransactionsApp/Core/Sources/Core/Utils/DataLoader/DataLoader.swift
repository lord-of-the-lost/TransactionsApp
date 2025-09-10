//
//  DataLoader.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Foundation

public enum DataLoaderError: Error {
    case fileNotFound
    case decodingError
}

public struct DataLoader: Sendable {
    private let bundle: Bundle
    private let decoder: PropertyListDecoder

    public init(bundle: Bundle = .main, decoder: PropertyListDecoder = .init()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    public func load<T: Decodable & Sendable>(
        file name: String,
        ext: String = Constants.FileExtension.plist,
        completion: @escaping @Sendable (Result<T, DataLoaderError>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result: Result<T, DataLoaderError> = {
                guard let url = self.bundle.url(forResource: name, withExtension: ext) else {
                    return .failure(.fileNotFound)
                }
                do {
                    let data = try Data(contentsOf: url)
                    let model = try self.decoder.decode(T.self, from: data)
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
public extension DataLoader {
    enum Constants {
        public enum FileExtension {
            public static let plist: String = "plist"
        }
        
        public enum FileName {
            public static let transactions: String = "Transactions"
            public static let rates: String = "Rates"
        }
    }
}
