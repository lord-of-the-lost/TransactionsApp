//
//  ProductsListPresenter.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 21.05.2025.
//

import UIKit

protocol ProductsListRouterProtocol: AnyObject {
    func showTransactions(for sku: String)
}

final class ProductsListRouter {
    weak var viewController: UIViewController?
}

// MARK: - ProductsListRouterProtocol
extension ProductsListRouter: ProductsListRouterProtocol {
    func showTransactions(for sku: String) {
       
    }
} 
