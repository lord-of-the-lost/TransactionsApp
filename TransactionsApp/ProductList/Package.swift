// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductList",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ProductList",
            targets: ["ProductList"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../ProductTransactions")
    ],
    targets: [
        .target(
            name: "ProductList",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "ProductTransactions", package: "ProductTransactions")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
