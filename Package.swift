// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cry",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "cry", dependencies: ["Utility"]),
        .testTarget(name: "cryTests", dependencies: ["cry"]),
    ]
)
