// swift-tools-version:4.2
import PackageDescription

let pkg = Package(
    name: "Version",
    products: [
        .library(name: "Version", targets: ["Version"]),
    ],
    targets: [
        .target(name: "Version", path: "Sources"),
    ],
    swiftLanguageVersions: [.v4, .v4_2, .version("5")]
)

#if !os(Linux)
// testing on Linux not necessary since we have no platform specific code
// thus if there are any issues, they are Swift bugs
// would support it if Linux testing wasn‘t a PITA
pkg.targets.append(.testTarget(name: "Tests.Version.mxcl", dependencies: ["Version"], path: "Tests"))
#endif
