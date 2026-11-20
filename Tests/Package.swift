// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AtomosTests",
    products: [
        .executable(
            name: "t_at_time",
            targets: ["t_at_time"]
        ),
    ],
    dependencies: [
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "t_at_time",
            dependencies: [.product(name: "Atomos", package: "Atomos")]
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
