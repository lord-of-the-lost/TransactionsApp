//
//  ProductTransactionsRouter.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import UIKit

final class ProductTransactionsRouter {
    weak var viewController: UIViewController?
}

extension ProductTransactionsRouter: ProductTransactionsRouterProtocol {
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
