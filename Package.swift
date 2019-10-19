// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cry",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        .package(url: "https://github.com/johnsundell/files", from: "2.2.1"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.9.0"),
    ],
    targets: [
        .target(name: "CryCipher", dependencies: ["CryptoSwift"]),
        .target(name: "CryCommands", dependencies: ["Utility", "Files", "CryCipher"]),
        .target(name: "CryCLI", dependencies: ["CryCommands"]),
        .testTarget(name: "CryCipherTests", dependencies: ["CryCipher"]),
    ]
)
