//
//  ProductTransactionsPresenter.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Core

final class ProductTransactionsPresenter {
    private weak var view: ProductTransactionsViewProtocol?
    private let router: ProductTransactionsRouterProtocol
    private var rates: [ExchangeRate] = []
    private let product: ProductItem
    
    init(router: ProductTransactionsRouterProtocol, product: ProductItem) {
        self.router = router
        self.product = product
    }
}

// MARK: - ProductTransactionsPresenterProtocol
extension ProductTransactionsPresenter: ProductTransactionsPresenterProtocol {
    func setupView(_ view: ProductTransactionsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func updateView(with model: ProductTransactionsViewModel) {
        view?.updateView(model)
    }
}

// MARK: - Private Methods
private extension ProductTransactionsPresenter {
    typealias Product = ProductTransactionsViewModel.ProductTransactionItem
    
    func loadData() {
        DataLoader.loadExchangeRates { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let rates):
                self.rates = rates.compactMap(ExchangeRate.init)
                self.updateTransactions()
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
    
    func updateTransactions() {
        let items = product.transactions.map { createViewModelItem(from: $0) }
        let total = calculateTotal(from: items)
        let viewModel = createViewModel(with: items, total: total)
        view?.updateView(viewModel)
    }
    
    func createViewModelItem(from transaction: Transaction) -> Product {
        let originalPrice = CurrencyFormatter.format(amount: transaction.amount, currency: transaction.currency)
        let amountInGBP = CurrencyConverter.convertToGBP(amount: transaction.amount, currency: transaction.currency, rates: rates)
        let convertedPrice = CurrencyFormatter.format(amount: amountInGBP, currency: Constants.gbpCurrencyCode)
        return ProductTransactionsViewModel.ProductTransactionItem(originalPrice: originalPrice, convertedPrice: convertedPrice)
    }
    
    func calculateTotal(from items: [Product]) -> Double {
        items.reduce(0.0) {
            $0 + CurrencyFormatter.extractAmount(from: $1.convertedPrice, currency: Constants.gbpCurrencyCode)
        }
    }
    
    func createViewModel(with items: [Product], total: Double) -> ProductTransactionsViewModel {
        let title = String(format: Constants.transactionsTitleFormat, product.sku)
        let sectionHeader = String(format: Constants.totalSectionHeaderFormat, CurrencyFormatter.format(amount: total, currency: Constants.gbpCurrencyCode))
        return ProductTransactionsViewModel(titleText: title, sectionHeader: sectionHeader, items: items)
    }
}

// MARK: - Constants
private extension ProductTransactionsPresenter {
    enum Constants {
        static let gbpCurrencyCode = "GBP"
        static let transactionsTitleFormat = "Transactions for %@"
        static let totalSectionHeaderFormat = "Total: %@"
    }
}
