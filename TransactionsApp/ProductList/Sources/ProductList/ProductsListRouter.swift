//
//  ProductsListPresenter.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

import UIKit

final class ProductsListRouter {
    weak var viewController: UIViewController?
}

// MARK: - ProductsListRouterProtocol
extension ProductsListRouter: ProductsListRouterProtocol {
    func showTransactions(for sku: String) {
       
    }
} 
