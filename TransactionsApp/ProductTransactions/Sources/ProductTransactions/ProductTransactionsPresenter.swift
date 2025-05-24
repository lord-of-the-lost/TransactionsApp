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
        let items = product.transactions.compactMap { createViewModelItem(from: $0) }
        let total = calculateTotal(from: items)
        let viewModel = createViewModel(with: items, total: total)
        view?.updateView(viewModel)
    }

    func createViewModelItem(from transaction: Transaction) -> Product? {
        guard let currency = Currency(rawValue: transaction.currency) else {
            assertionFailure("Unsupported currency: \(transaction.currency)")
            return nil
        }

        let originalMoney = Money(amount: transaction.amount, currency: currency)
        let originalPrice = CurrencyFormatter.format(originalMoney)

        let convertedMoney: Money
        do {
            convertedMoney = try CurrencyConverter.convert(originalMoney, to: .gbp, using: rates)
        } catch {
            assertionFailure("Conversion failed: \(error)")
            return nil
        }

        let convertedPrice = CurrencyFormatter.format(convertedMoney)

        return ProductTransactionsViewModel.ProductTransactionItem(
            originalPrice: originalPrice,
            convertedPrice: convertedPrice
        )
    }

    func calculateTotal(from items: [Product]) -> Double {
        items.compactMap {
            CurrencyFormatter.extractAmount(from: $0.convertedPrice, currency: .gbp)
        }.reduce(0, +)
    }

    func createViewModel(with items: [Product], total: Double) -> ProductTransactionsViewModel {
        let title = String(format: Constants.transactionsTitleFormat, product.sku)
        let totalMoney = Money(amount: total, currency: .gbp)
        let sectionHeader = String(format: Constants.totalSectionHeaderFormat, CurrencyFormatter.format(totalMoney))
        return ProductTransactionsViewModel(titleText: title, sectionHeader: sectionHeader, items: items)
    }
}

// MARK: - Constants
private extension ProductTransactionsPresenter {
    enum Constants {
        static let transactionsTitleFormat = "Transactions for %@"
        static let totalSectionHeaderFormat = "Total: %@"
    }
}
