//
//  ProductsListAssembly.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Core

public enum ProductsListAssembly {
    public static func assembly() -> ProductsListViewController {
        let router = ProductsListRouter()
        let dataLoader = DataLoader()
        let presenter = ProductsListPresenter(router: router, dataLoader: dataLoader)
        let controller = ProductsListViewController(presenter: presenter)
        router.viewController = controller
        return controller
    }
}
