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

for target in package.targets {
    switch target.type {
    case .regular, .executable, .test, .macro:
        var settings = target.swiftSettings ?? []

        settings.append(
            .treatAllWarnings(as: .error)
        )

        target.swiftSettings = settings

    case .plugin, .system, .binary:
        break

    @unknown default:
        break
    }
}
