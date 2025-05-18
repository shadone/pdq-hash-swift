// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PDQ",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PDQ",
            targets: ["PDQ"]
        ),
        .executable(name: "pdq-photo-hasher", targets: ["pdq-photo-hasher"])
    ],
    targets: [
        .target(
            name: "PDQ",
            dependencies: [
                "CPDQ",
            ]),
        .target(
            name: "CPDQ",
            exclude: ["LICENSE"],
            sources: ["src"],
            publicHeadersPath: "include/public",
            cxxSettings: [
                 .headerSearchPath("./include/private"),
            ],
        ),
        .testTarget(
            name: "PDQTests",
            dependencies: ["PDQ"]
        ),
        .executableTarget(
            name: "pdq-photo-hasher",
            dependencies: ["PDQ"],
        )
    ],
    cxxLanguageStandard: .cxx17,
)
