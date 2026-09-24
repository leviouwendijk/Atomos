// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Atomos",
    products: [
        .library(
            name: "Atomos",
            targets: ["Atomos"]
        ),
        .executable(
            name: "t_at_time",
            targets: ["t_at_time"]
        ),
    ],
    targets: [
        .target(
            name: "Atomos"
        ),
        .executableTarget(
            name: "t_at_time",
            dependencies: ["Atomos"],
            path: "Testing/t_at_time"
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
