//
//  ProductsListPresenter.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Core
import Foundation

final class ProductsListPresenter {
    private weak var view: ProductsListViewProtocol?
    private let router: ProductsListRouterProtocol
    private var transactions: [Transaction] = []

    init(router: ProductsListRouterProtocol) {
        self.router = router
    }
}

// MARK: - ProductsListPresenterProtocol
extension ProductsListPresenter: ProductsListPresenterProtocol {
    func setupView(_ view: ProductsListViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        loadTransactions()
    }

    func didSelectProduct(_ sku: String) {
        router.showTransactions(for: sku)
    }
}

// MARK: - Private Methods
private extension ProductsListPresenter {
    func loadTransactions() {
        do {
            let model = try DataLoader.loadTransactions()
            transactions = model.compactMap { Transaction($0) }
            updateProductsList()
        } catch {
            view?.showError(error)
        }
    }
    
    func updateProductsList() {
        let products = makeProductList(from: transactions)
        view?.updateProductsList(products)
    }
    
    func makeProductList(from transactions: [Transaction]) -> [ProductItem] {
        var productMap: [String: Int] = [:]
        
        for transaction in transactions {
            productMap[transaction.sku, default: 0] += 1
        }
        
        return productMap
            .map { ProductItem(sku: $0.key, count: "\($0.value) transactions") }
            .sorted { $0.sku.localizedCompare($1.sku) == .orderedAscending }
    }
}


