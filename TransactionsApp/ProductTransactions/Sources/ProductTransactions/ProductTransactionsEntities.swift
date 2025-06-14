//
//  ProductTransactionsEntities.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Foundation

// MARK: View Model
struct ProductTransactionsViewModel {
    let titleText: String
    let sectionHeader: String
    let items: [ProductTransactionItem]
    
    struct ProductTransactionItem {
        let originalPrice: String
        let convertedPrice: String
    }
}

// MARK: Presenter
protocol ProductTransactionsPresenterProtocol: AnyObject {
    func setupView(_ view: ProductTransactionsViewProtocol)
    func viewDidLoad()
    func updateView(with model: ProductTransactionsViewModel)
}

// MARK: Controller
protocol ProductTransactionsViewProtocol: AnyObject {
    func updateView(_ model: ProductTransactionsViewModel)
    func showError(_ error: Error)
}

// MARK: Router
protocol ProductTransactionsRouterProtocol: AnyObject {
    func close()
}
