// swift-tools-version:5.0
import PackageDescription

let pkg = Package(
    name: "Version",
    products: [
        .library(name: "Version", targets: ["Version"]),
    ],
    targets: [
        .target(name: "Version", path: "Sources"),
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)

#if !os(Linux)
pkg.targets.append(.testTarget(name: "Tests", dependencies: ["Version"], path: "Tests"))
#endif
