// swift-tools-version:5.3
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

#if swift(>=5.4) || os(macOS)
pkg.targets.append(.testTarget(name: "Tests.Version.mxcl", dependencies: ["Version"], path: "Tests"))
#endif
