// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Trimbot",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "TrimbotCore", targets: ["TrimbotCore"]),
        .executable(name: "trimbot", targets: ["TrimbotCLI"]),
        .executable(name: "TrimbotApp", targets: ["TrimbotApp"]),
    ],
    targets: [
        .target(name: "TrimbotCore"),
        .executableTarget(name: "TrimbotCLI", dependencies: ["TrimbotCore"]),
        .executableTarget(name: "TrimbotApp", dependencies: ["TrimbotCore"]),
        .testTarget(name: "TrimbotCoreTests", dependencies: ["TrimbotCore"]),
    ]
)
