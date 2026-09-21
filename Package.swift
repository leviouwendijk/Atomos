// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Atomos",
    products: [
        .library(
            name: "Atomos",
            targets: ["Atomos"]
        ),
    ],
    targets: [
        .target(
            name: "Atomos"
        ),
    ],
    swiftLanguageModes: [.v6]
)
