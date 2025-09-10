//
//  ProductTransactionsAssembly.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Core
import UIKit

@MainActor
public enum ProductTransactionsAssembly {
    public static func assembly(product: ProductItem) -> ProductTransactionsViewController {
        let router = ProductTransactionsRouter()
        let dataLoader = DataLoader()
        let presenter = ProductTransactionsPresenter(router: router, product: product, dataLoader: dataLoader)
        let controller = ProductTransactionsViewController(presenter: presenter)
        router.viewController = controller
        return controller
    }
}
