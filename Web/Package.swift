// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PipAwakeWeb",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/twostraws/Ignite.git", from: "0.7.2")
    ],
    targets: [
        .executableTarget(
            name: "PipAwakeWeb",
            dependencies: ["Ignite"],
            path: "Sources"
        )
    ]
)
