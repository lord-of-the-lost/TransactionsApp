//
//  ProductTransactionsAssembly.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import UIKit

public enum ProductTransactionsAssembly {
    public static func assembly(sku: String) -> ProductTransactionsViewController {
        let router = ProductTransactionsRouter()
        let presenter = ProductTransactionsPresenter(router: router, sku: sku)
        let controller = ProductTransactionsViewController(presenter: presenter)
        router.viewController = controller
        return controller
    }
}
