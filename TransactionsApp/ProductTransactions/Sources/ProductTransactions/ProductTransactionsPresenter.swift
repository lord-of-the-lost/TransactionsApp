//
//  ProductTransactionsPresenter.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Core
import Foundation

@MainActor
final class ProductTransactionsPresenter {
    private weak var view: ProductTransactionsViewProtocol?
    private let router: ProductTransactionsRouterProtocol
    private let dataLoader: DataLoader
    private let product: ProductItem
    private var rates: [ExchangeRate] = []

    init(
        router: ProductTransactionsRouterProtocol,
        product: ProductItem,
        dataLoader: DataLoader
    ) {
        self.router = router
        self.product = product
        self.dataLoader = dataLoader
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
    
    @MainActor
    func loadData() {
        dataLoader.load(file: DataLoader.Constants.FileName.rates) { [weak self] (result: Result<[ExchangeRateModel], DataLoaderError>) in
            guard let self else { return }

            switch result {
            case .success(let models):
                let rates = models.compactMap(ExchangeRate.init)
                
                Task { @MainActor in
                    self.rates = rates
                    self.updateTransactions()
                }

            case .failure(let error):
                Task { @MainActor in
                    self.view?.showError(error)
                }
            }
        }
    }

    @MainActor
    func updateTransactions() {
        let items = product.transactions.compactMap { createViewModelItem(from: $0) }
        let total = calculateTotal(from: product.transactions)
        let viewModel = createViewModel(with: items, total: total)
        view?.updateView(viewModel)
    }

    func createViewModelItem(from transaction: Transaction) -> Product? {
        let originalMoney = transaction.money
        let originalPrice = CurrencyFormatter.format(originalMoney)

        let convertedMoney: Money
        do {
            convertedMoney = try CurrencyConverter.convert(originalMoney, to: .gbp, using: rates)
        } catch {
            assertionFailure("Conversion failed: \(error)")
            return nil
        }

        let convertedPrice = CurrencyFormatter.format(convertedMoney)

        return Product(originalPrice: originalPrice, convertedPrice: convertedPrice)
    }

    func calculateTotal(from transactions: [Transaction]) -> Decimal {
        transactions.compactMap { transaction in
            try? CurrencyConverter.convert(transaction.money, to: .gbp, using: rates).amount
        }
        .reduce(Decimal(0), +)
    }

    func createViewModel(with items: [Product], total: Decimal) -> ProductTransactionsViewModel {
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
