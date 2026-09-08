// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SharedEventLib",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SharedEventLib",
            targets: ["SharedEventLib"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/CleverTap/clevertap-ios-sdk",
            from: "6.0.0"
        )
    ],
    targets: [
        .target(
            name: "SharedEventLib",
            dependencies: [
                .product(name: "CleverTapSDK", package: "clevertap-ios-sdk")
            ],
            path: "Sources/SharedEventLib"
        )
    ]
)
