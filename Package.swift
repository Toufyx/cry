// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cry",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        .package(url: "https://github.com/johnsundell/files", from: "2.2.1")
    ],
    targets: [
        .target(name: "cry", dependencies: ["Utility", "Files"]),
        .testTarget(name: "cryTests", dependencies: ["cry"]),
    ]
)
