// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductTransactions",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ProductTransactions",
            targets: ["ProductTransactions"]),
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "ProductTransactions",
            dependencies: [.product(name: "Core", package: "Core")],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
