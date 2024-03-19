// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "metal_vector_add",
     platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "metal_vector_add"
        ),
    ]
)
