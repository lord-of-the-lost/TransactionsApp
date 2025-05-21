//
//  ProductsListPresenter.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Core
import Foundation

protocol ProductsListPresenterProtocol: AnyObject {
    func setupView(_ view: ProductsListViewProtocol)
    func viewDidLoad()
    func didSelectProduct(_ sku: String)
}

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
        var products: [String: Int] = [:]
        
        for transaction in transactions {
            products[transaction.sku, default: 0] += 1
        }
        
        view?.updateProductsList(products)
    }
}
