//
//  ProductsListPresenter.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Core

@MainActor
final class ProductsListPresenter {
    private weak var view: ProductsListViewProtocol?
    private let router: ProductsListRouterProtocol
    private let dataLoader: DataLoader
    private var products: [ProductItem] = []
    
    init(router: ProductsListRouterProtocol, dataLoader: DataLoader) {
        self.router = router
        self.dataLoader = dataLoader
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
        dataLoader.load(file: DataLoader.Constants.FileName.transactions) { [weak self] (result: Result<[TransactionModel], DataLoaderError>) in
            guard let self else { return }

            switch result {
            case .success(let models):
                let transactions = models.compactMap(Transaction.init)
                
                Task { @MainActor in
                    self.products = groupTransactionsBySKU(transactions)
                    self.updateProductsList()
                }

            case .failure(let error):
                Task { @MainActor in
                    self.view?.showError(error)
                }
            }
        }
    }

    func groupTransactionsBySKU(_ transactions: [Transaction]) -> [ProductItem] {
        Dictionary(grouping: transactions, by: { $0.sku })
            .map { ProductItem(sku: $0.key, transactions: $0.value) }
    }

    func updateProductsList() {
        let viewModels = products.map { ProductItemViewModel.init(from: $0) }
        view?.updateProductsList(viewModels)
    }
}
