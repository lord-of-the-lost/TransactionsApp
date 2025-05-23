//
//  ProductsListPresenter.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Core
import ProductTransactions
import UIKit

final class ProductsListRouter {
    weak var viewController: UIViewController?
}

// MARK: - ProductsListRouterProtocol
extension ProductsListRouter: ProductsListRouterProtocol {
    func showTransactions(for product: ProductItem) {
        let controller = ProductTransactionsAssembly.assembly(product: product)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
} 
