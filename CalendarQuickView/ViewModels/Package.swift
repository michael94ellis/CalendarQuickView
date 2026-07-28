// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "ViewModels",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ViewModels",
            targets: ["ViewModels"]
        ),
    ],
    dependencies: [
        .package(path: "../../Shared/DesignToken"),
    ],
    targets: [
        .target(
            name: "ViewModels",
            dependencies: [
                "DesignToken",
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)
