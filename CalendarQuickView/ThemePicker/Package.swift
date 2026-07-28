// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "ThemePicker",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ThemePicker",
            targets: ["ThemePicker"]
        ),
    ],
    dependencies: [
        .package(path: "../../Shared/DesignToken"),
        .package(path: "../ViewModels"),
    ],
    targets: [
        .target(
            name: "ThemePicker",
            dependencies: [
                "DesignToken",
                "ViewModels",
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)
