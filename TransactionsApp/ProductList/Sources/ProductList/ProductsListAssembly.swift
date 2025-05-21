//
//  ProductsListAssembly.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

public enum ProductsListAssembly {
    public static func assembly() -> ProductsListViewController {
        let router = ProductsListRouter()
        let presenter = ProductsListPresenter(router: router)
        let controller = ProductsListViewController(presenter: presenter)
        router.viewController = controller
        return controller
    }
}
