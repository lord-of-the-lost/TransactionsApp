//
//  ProductListEntities.swift
//  ProductList
//
//  Created by Николай Игнатов on 22.05.2025.
//

// MARK: View Model
struct ProductItem {
    let sku: String
    let count: String
}

// MARK: Presenter
protocol ProductsListPresenterProtocol: AnyObject {
    func setupView(_ view: ProductsListViewProtocol)
    func viewDidLoad()
    func didSelectProduct(_ sku: String)
}

// MARK: Controller
protocol ProductsListViewProtocol: AnyObject {
    func updateProductsList(_ products: [ProductItem])
    func showError(_ error: Error)
}

// MARK: Router
protocol ProductsListRouterProtocol: AnyObject {
    func showTransactions(for sku: String)
}
