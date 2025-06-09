// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "snappy",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Snappy",
            targets: ["Snappy"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.4"),
        .package(url: "https://github.com/apple/swift-system", from: "1.5.0"),
    ],
    targets: [
        .target(name: "SnappyC"), // C Version, originally from https://github.com/andikleen/snappy-c
        .target(name: "Snappy", dependencies: ["SnappyC", .product(name: "SystemPackage", package: "swift-system")]),
        .testTarget(
            name: "SnappyTests",
            dependencies: ["Snappy"],
            resources: [.process("Data")]
        ),
    ]
)
