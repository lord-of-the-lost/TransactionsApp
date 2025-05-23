//
//  ProductsListPresenter.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Core

final class ProductsListPresenter {
    private weak var view: ProductsListViewProtocol?
    private let router: ProductsListRouterProtocol
    private var products: [ProductItem] = []

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

    func didSelectProduct(at index: Int) {
        guard let product = products[safe: index] else { return }
        router.showTransactions(for: product)
    }
}

// MARK: - Private Methods
private extension ProductsListPresenter {
    func loadTransactions() {
        DataLoader.loadTransactions { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let models):
                let transactions = models.compactMap(Transaction.init)
                self.products = groupTransactionsBySKU(transactions)
                self.updateProductsList()
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }

    func groupTransactionsBySKU(_ transactions: [Transaction]) -> [ProductItem] {
        let grouped = Dictionary(grouping: transactions, by: { $0.sku })
        return grouped.map { ProductItem(sku: $0.key, transactions: $0.value) }
            .sorted { $0.sku.localizedCompare($1.sku) == .orderedAscending }
    }

    func updateProductsList() {
        let viewModels = products.map { ProductItemViewModel.init(from: $0) }
        view?.updateProductsList(viewModels)
    }
}
