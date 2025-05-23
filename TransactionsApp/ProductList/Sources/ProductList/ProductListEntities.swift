//
//  ProductListEntities.swift
//  ProductList
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Core

// MARK: View Model
struct ProductItemViewModel {
    let sku: String
    let count: String
    
    init(from model: ProductItem) {
        self.sku = model.sku
        self.count = "\(model.transactions.count) transactions"
    }
}

// MARK: Presenter
protocol ProductsListPresenterProtocol: AnyObject {
    func setupView(_ view: ProductsListViewProtocol)
    func viewDidLoad()
    func didSelectProduct(at index: Int)
}

// MARK: Controller
protocol ProductsListViewProtocol: AnyObject {
    func updateProductsList(_ products: [ProductItemViewModel])
    func showError(_ error: Error)
}

// MARK: Router
protocol ProductsListRouterProtocol: AnyObject {
    func showTransactions(for product: ProductItem)
}
