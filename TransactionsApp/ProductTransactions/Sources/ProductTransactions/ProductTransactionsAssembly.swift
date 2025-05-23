//
//  ProductTransactionsAssembly.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Core
import UIKit

public enum ProductTransactionsAssembly {
    public static func assembly(product: ProductItem) -> ProductTransactionsViewController {
        let router = ProductTransactionsRouter()
        let presenter = ProductTransactionsPresenter(router: router, product: product)
        let controller = ProductTransactionsViewController(presenter: presenter)
        router.viewController = controller
        return controller
    }
}
