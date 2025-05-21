// swift-tools-version: 5.9
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
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "ProductList",
            dependencies: [.product(name: "Core", package: "Core")]
        )
    ]
)
