// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "snappy",
    products: [
        .library(
            name: "Snappy",
            targets: ["Snappy"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-system", from: "1.2.1"),
    ],
    targets: [
        .target(name: "SnappyC"), // C Version, originally from https://github.com/andikleen/snappy-c
        .target(name: "Snappy", dependencies: ["SnappyC", .product(name: "SystemPackage", package: "swift-system")]),
        .testTarget(
            name: "SnappyTests",
            dependencies: ["Snappy"]),
    ]
)
