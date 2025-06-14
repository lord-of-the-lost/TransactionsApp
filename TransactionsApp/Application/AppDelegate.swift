//
//  AppDelegate.swift
//  TransactionsApp
//
//  Created by Николай Игнатов on 20.05.2025.
//

import UIKit
import ProductList

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let initialController = ProductsListAssembly.assembly()
        let navigationController = UINavigationController(rootViewController: initialController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

