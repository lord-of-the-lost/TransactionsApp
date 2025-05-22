//
//  ProductTransactionsPresenter.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Core
import Foundation

final class ProductTransactionsPresenter {
    private weak var view: ProductTransactionsViewProtocol?
    private let router: ProductTransactionsRouterProtocol
    private var allTransactions: [Transaction] = []
    private var rates: [ExchangeRate] = []
    private let sku: String
    
    init(router: ProductTransactionsRouterProtocol, sku: String) {
        self.router = router
        self.sku = sku
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
    typealias ProductItem = ProductTransactionsViewModel.ProductTransactionItem
    
    func loadData() {
        do {
            allTransactions = try DataLoader.loadTransactions().compactMap(Transaction.init)
            rates = try DataLoader.loadExchangeRates().compactMap(ExchangeRate.init)
            updateTransactions()
        } catch {
            view?.showError(error)
        }
    }
    
    func updateTransactions() {
        let filteredTransactions = filterTransactions(for: sku)
        let items = filteredTransactions.map { createViewModelItem(from: $0) }
        let total = calculateTotal(from: items)
        let viewModel = createViewModel(with: items, total: total)
        view?.updateView(viewModel)
    }
    
    func filterTransactions(for sku: String) -> [Transaction] {
        allTransactions.filter { $0.sku == sku }
    }
    
    func createViewModelItem(from transaction: Transaction) -> ProductItem {
        let originalPrice = CurrencyFormatter.format(amount: transaction.amount, currency: transaction.currency)
        let amountInGBP = CurrencyConverter.convertToGBP(amount: transaction.amount, currency: transaction.currency, rates: rates)
        let convertedPrice = CurrencyFormatter.format(amount: amountInGBP, currency: Constants.gbpCurrencyCode)
        return ProductTransactionsViewModel.ProductTransactionItem(originalPrice: originalPrice, convertedPrice: convertedPrice)
    }
    
    func calculateTotal(from items: [ProductItem]) -> Double {
        items.reduce(0.0) {
            $0 + CurrencyFormatter.extractAmount(from: $1.convertedPrice, currency: Constants.gbpCurrencyCode)
        }
    }
    
    func createViewModel(with items: [ProductItem], total: Double) -> ProductTransactionsViewModel {
        let title = String(format: Constants.transactionsTitleFormat, sku)
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
