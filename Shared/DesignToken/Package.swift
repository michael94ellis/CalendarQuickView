// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignToken",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "DesignToken",
            targets: ["DesignToken"]
        ),
    ],
    targets: [
        .target(
            name: "DesignToken"
        ),
    ],
    swiftLanguageModes: [.v6]
)
