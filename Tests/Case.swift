/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import Version
import XCTest

class VersionTests: XCTestCase {

    func testEquality() {
        let versions: [Version] = [Version(1,2,3), Version(0,0,0),
            Version(0,0,0, prereleaseIdentifiers: ["alpha"], buildMetadataIdentifiers: ["yol"]), Version(0,0,0, prereleaseIdentifiers: ["alpha.1"], buildMetadataIdentifiers: ["pol"]),
            Version(0,1,2), Version(10,7,3),
        ]
        // Test that each version is equal to itself and not equal to others.
        for (idx, version) in versions.enumerated() {
            for (ridx, rversion) in versions.enumerated() {
                if idx == ridx {
                    XCTAssertEqual(version, rversion)
                    // Construct the object again with different initializer.
                    XCTAssertEqual(version,
                        Version(rversion.major, rversion.minor, rversion.patch,
                            prereleaseIdentifiers: rversion.prereleaseIdentifiers,
                            buildMetadataIdentifiers: rversion.buildMetadataIdentifiers))
                } else {
                    XCTAssertNotEqual(version, rversion)
                }
            }
        }
    }

    func testEqualityWithBuildMetadata() {
        let versions: [(Version, Version)] = [
            (Version(1,2,3, buildMetadataIdentifiers: ["123"]), Version(1,2,3, buildMetadataIdentifiers: ["987"])),
            (Version(1,2,3, buildMetadataIdentifiers: ["123"]), Version(1,2,3, buildMetadataIdentifiers: ["123"])),
            (Version(4,5,6, prereleaseIdentifiers: ["alpha1"], buildMetadataIdentifiers: ["123"]), Version(4,5,6, prereleaseIdentifiers: ["alpha1"], buildMetadataIdentifiers: ["987"])),
            (Version(4,5,6, prereleaseIdentifiers: ["alpha1"], buildMetadataIdentifiers: ["123"]), Version(4,5,6, prereleaseIdentifiers: ["alpha1"], buildMetadataIdentifiers: ["123"]))
        ]

        for (v1, v2) in versions {
            XCTAssertEqual(v1, v2)
            XCTAssertLessThanOrEqual(v1, v2)
            XCTAssertGreaterThanOrEqual(v1, v2)
        }
    }

    func testHashable() {
        let versions: [Version] = [Version(1,2,3), Version(1,2,3), Version(1,2,3),
            Version(1,0,0, prereleaseIdentifiers: ["alpha"]), Version(1,0,0, prereleaseIdentifiers: ["alpha"]),
            Version(1,0,0), Version(1,0,0)
        ]
        XCTAssertEqual(Set(versions), Set([Version(1,0,0, prereleaseIdentifiers: ["alpha"]), Version(1,2,3), Version(1,0,0)]))

        XCTAssertEqual(Set([Version(1,2,3)]), Set([Version(1,2,3)]))
        XCTAssertNotEqual(Set([Version(1,2,3)]), Set([Version(1,2,3, prereleaseIdentifiers: ["alpha"])]))
        XCTAssertNotEqual(Set([Version(1,2,3)]), Set([Version(1,2,3, buildMetadataIdentifiers: ["1011"])]))
    }

    func testDescription() {
        let v = Version("123.234.345-alpha.beta+sha1.1011")
        XCTAssertEqual(v?.description, "123.234.345-alpha.beta+sha1.1011")
        XCTAssertEqual(v?.major, 123)
        XCTAssertEqual(v?.minor, 234)
        XCTAssertEqual(v?.patch, 345)
        XCTAssertEqual(v?.prereleaseIdentifiers, ["alpha", "beta"])
        XCTAssertEqual(v?.buildMetadataIdentifiers, ["sha1", "1011"])
    }

    func testFromString() {
        XCTAssertNil(Version(""))
        XCTAssertNil(Version("1"))
        XCTAssertNil(Version("1.2"))
        XCTAssertNil(Version("1.2.3.4"))
        XCTAssertNil(Version("1.2.3.4.5"))
        XCTAssertNil(Version("a"))
        XCTAssertNil(Version("1.a"))
        XCTAssertNil(Version("a.2"))
        XCTAssertNil(Version("a.2.3"))
        XCTAssertNil(Version("1.a.3"))
        XCTAssertNil(Version("1.2.a"))
        XCTAssertNil(Version("-1.2.3"))
        XCTAssertNil(Version("1.-2.3"))
        XCTAssertNil(Version("1.2.-3"))
        XCTAssertNil(Version(".1.2.3"))
        XCTAssertNil(Version("v.1.2.3"))
        XCTAssertNil(Version("1.2..3"))
        XCTAssertNil(Version("v1.2.3"))
        XCTAssertNil(Version(".1.2"))
        XCTAssertNil(Version(".1"))

        XCTAssertNil(Version("-1.1.1"))
        XCTAssertNil(Version("1.-1.1"))
        XCTAssertNil(Version("1.1.-1"))
        XCTAssertNil(Version("1.-1.-1"))
        XCTAssertNil(Version("-1.-1.-1"))
        XCTAssertNil(Version("10..0.0"))
        XCTAssertNil(Version("10.0..0"))
        XCTAssertNil(Version("10.0.0."))
        XCTAssertNil(Version("10.0.0.."))
        XCTAssertNil(Version("10.0.0.0"))
        XCTAssertNil(Version("10.0.0.-1"))

        XCTAssertEqual(Version(1,2,3), Version(1,2,3))
        XCTAssertEqual(Version(1,2,3), Version(01,002,0003))
        XCTAssertEqual(Version(0,9,21), Version(0,9,21))
        XCTAssertEqual(Version(0,9,21, prereleaseIdentifiers: ["alpha", "beta"], buildMetadataIdentifiers: ["1011"]),
            Version("0.9.21-alpha.beta+1011"))
        XCTAssertEqual(Version(0,9,21, prereleaseIdentifiers: [], buildMetadataIdentifiers: ["1011"]), Version("0.9.21+1011"))
    }

    func testComparable() {
        do {
            let v1 = Version(1,2,3)
            let v2 = Version(2,1,2)
            XCTAssertLessThan(v1, v2)
            XCTAssertLessThanOrEqual(v1, v2)
            XCTAssertGreaterThan(v2, v1)
            XCTAssertGreaterThanOrEqual(v2, v1)
            XCTAssertNotEqual(v1, v2)

            XCTAssertLessThanOrEqual(v1, v1)
            XCTAssertGreaterThanOrEqual(v1, v1)
            XCTAssertLessThanOrEqual(v2, v2)
            XCTAssertGreaterThanOrEqual(v2, v2)
        }

        do {
            let v3 = Version(2,1,3)
            let v4 = Version(2,2,2)
            XCTAssertLessThan(v3, v4)
            XCTAssertLessThanOrEqual(v3, v4)
            XCTAssertGreaterThan(v4, v3)
            XCTAssertGreaterThanOrEqual(v4, v3)
            XCTAssertNotEqual(v3, v4)

            XCTAssertLessThanOrEqual(v3, v3)
            XCTAssertGreaterThanOrEqual(v3, v3)
            XCTAssertLessThanOrEqual(v4, v4)
            XCTAssertGreaterThanOrEqual(v4, v4)
        }

        do {
            let v5 = Version(2,1,2)
            let v6 = Version(2,1,3)
            XCTAssertLessThan(v5, v6)
            XCTAssertLessThanOrEqual(v5, v6)
            XCTAssertGreaterThan(v6, v5)
            XCTAssertGreaterThanOrEqual(v6, v5)
            XCTAssertNotEqual(v5, v6)

            XCTAssertLessThanOrEqual(v5, v5)
            XCTAssertGreaterThanOrEqual(v5, v5)
            XCTAssertLessThanOrEqual(v6, v6)
            XCTAssertGreaterThanOrEqual(v6, v6)
        }

        do {
            let v7 = Version(0,9,21)
            let v8 = Version(2,0,0)
            XCTAssert(v7 < v8)
            XCTAssertLessThan(v7, v8)
            XCTAssertLessThanOrEqual(v7, v8)
            XCTAssertGreaterThan(v8, v7)
            XCTAssertGreaterThanOrEqual(v8, v7)
            XCTAssertNotEqual(v7, v8)

            XCTAssertLessThanOrEqual(v7, v7)
            XCTAssertGreaterThanOrEqual(v7, v7)
            XCTAssertLessThanOrEqual(v8, v8)
            XCTAssertGreaterThanOrEqual(v8, v8)
        }

        do {
            // Prerelease precedence tests taken directly from http://semver.org
            var tests: [Version] = [
                Version(1,0,0, prereleaseIdentifiers: ["alpha"]), Version(1,0,0, prereleaseIdentifiers: ["alpha","1"]), Version(1,0,0, prereleaseIdentifiers: ["alpha","beta"]), Version(1,0,0, prereleaseIdentifiers: ["beta"]),
                Version(1,0,0, prereleaseIdentifiers: ["beta","2"]), Version(1,0,0, prereleaseIdentifiers: ["beta","11"]), Version(1,0,0, prereleaseIdentifiers: ["rc","1"]), Version(1,0,0)
            ]

            var v1 = tests.removeFirst()
            for v2 in tests {
                XCTAssertLessThan(v1, v2)
                XCTAssertLessThanOrEqual(v1, v2)
                XCTAssertGreaterThan(v2, v1)
                XCTAssertGreaterThanOrEqual(v2, v1)
                XCTAssertNotEqual(v1, v2)

                XCTAssertLessThanOrEqual(v1, v1)
                XCTAssertGreaterThanOrEqual(v1, v1)
                XCTAssertLessThanOrEqual(v2, v2)
                XCTAssertGreaterThanOrEqual(v2, v2)

                v1 = v2
            }
        }
    }

    func testOrder() {
        XCTAssertLessThan(Version(0,0,0), Version(0,0,1))
        XCTAssertLessThan(Version(0,0,1), Version(0,1,0))
        XCTAssertLessThan(Version(0,1,0), Version(0,10,0))
        XCTAssertLessThan(Version(0,10,0), Version(1,0,0))
        XCTAssertLessThan(Version(1,0,0), Version(2,0,0))
        XCTAssert(!(Version(1,0,0) < Version(1,0,0)))
        XCTAssert(!(Version(2,0,0) < Version(1,0,0)))
    }

    func testRange() {
        switch Version(1,2,4) {
        case Version(1,2,3)..<Version(2,3,4):
            break
        default:
            XCTFail()
        }

        switch Version(1,2,4) {
        case Version(1,2,3)..<Version(2,3,4):
            break
        case Version(1,2,5)..<Version(1,2,6):
            XCTFail()
        default:
            XCTFail()
        }

        switch Version(1,2,4) {
        case Version(1,2,3)..<Version(1,2,4):
            XCTFail()
        case Version(1,2,5)..<Version(1,2,6):
            XCTFail()
        default:
            break
        }

        switch Version(1,2,4) {
        case Version(1,2,5)..<Version(2,0,0):
            XCTFail()
        case Version(2,0,0)..<Version(2,2,6):
            XCTFail()
        case Version(0,0,1)..<Version(0,9,6):
            XCTFail()
        default:
            break
        }
    }

    func testContains() {
        do {
            let range: Range<Version> = Version(1,0,0)..<Version(2,0,0)

            XCTAssertTrue(range.contains(Version(1,0,0)))
            XCTAssertTrue(range.contains(Version(1,5,0)))
            XCTAssertTrue(range.contains(Version(1,9,99999)))
            XCTAssertTrue(range.contains(Version(1,9,99999, buildMetadataIdentifiers: ["1232"])))

            XCTAssertFalse(range.contains(Version(1,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(1,5,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(2,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(2,0,0)))
        }

        do {
            let range: Range<Version> = Version(1,0,0)..<Version(2,0,0, prereleaseIdentifiers: ["beta"])

            XCTAssertTrue(range.contains(Version(1,0,0)))
            XCTAssertTrue(range.contains(Version(1,5,0)))
            XCTAssertTrue(range.contains(Version(1,9,99999)))
            XCTAssertTrue(range.contains(Version(1,0,1, prereleaseIdentifiers: ["alpha"])))
            XCTAssertTrue(range.contains(Version(2,0,0, prereleaseIdentifiers: ["alpha"])))

            XCTAssertFalse(range.contains(Version(1,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(2,0,0)))
            XCTAssertFalse(range.contains(Version(2,0,0, prereleaseIdentifiers: ["beta"])))
            XCTAssertFalse(range.contains(Version(2,0,0, prereleaseIdentifiers: ["clpha"])))
        }

        do {
            let range: Range<Version> = Version(1,0,0, prereleaseIdentifiers: ["alpha"])..<Version(2,0,0)
            XCTAssertTrue(range.contains(Version(1,0,0)))
            XCTAssertTrue(range.contains(Version(1,5,0)))
            XCTAssertTrue(range.contains(Version(1,9,99999)))
            XCTAssertTrue(range.contains(Version(1,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertTrue(range.contains(Version(1,0,0, prereleaseIdentifiers: ["beta"])))
            XCTAssertTrue(range.contains(Version(1,0,1, prereleaseIdentifiers: ["alpha"])))

            XCTAssertFalse(range.contains(Version(2,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(2,0,0, prereleaseIdentifiers: ["beta"])))
            XCTAssertFalse(range.contains(Version(2,0,0, prereleaseIdentifiers: ["clpha"])))
            XCTAssertFalse(range.contains(Version(2,0,0)))
        }

        do {
            let range: Range<Version> = Version(1,0,0)..<Version(1,1,0)
            XCTAssertTrue(range.contains(Version(1,0,0)))
            XCTAssertTrue(range.contains(Version(1,0,9)))

            XCTAssertFalse(range.contains(Version(1,1,0)))
            XCTAssertFalse(range.contains(Version(1,2,0)))
            XCTAssertFalse(range.contains(Version(1,5,0)))
            XCTAssertFalse(range.contains(Version(2,0,0)))
            XCTAssertFalse(range.contains(Version(1,0,0, prereleaseIdentifiers: ["beta"])))
            XCTAssertFalse(range.contains(Version(1,0,10, prereleaseIdentifiers: ["clpha"])))
            XCTAssertFalse(range.contains(Version(1,1,0, prereleaseIdentifiers: ["alpha"])))
        }

        do {
            let range: Range<Version> = Version(1,0,0)..<Version(1,1,0, prereleaseIdentifiers: ["alpha"])
            XCTAssertTrue(range.contains(Version(1,0,0)))
            XCTAssertTrue(range.contains(Version(1,0,9)))
            XCTAssertTrue(range.contains(Version(1,0,1, prereleaseIdentifiers: ["beta"])))
            XCTAssertTrue(range.contains(Version(1,0,10, prereleaseIdentifiers: ["clpha"])))

            XCTAssertFalse(range.contains(Version(1,1,0)))
            XCTAssertFalse(range.contains(Version(1,2,0)))
            XCTAssertFalse(range.contains(Version(1,5,0)))
            XCTAssertFalse(range.contains(Version(2,0,0)))
            XCTAssertFalse(range.contains(Version(1,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(1,1,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(1,1,0, prereleaseIdentifiers: ["beta"])))
        }

        //MARK: closed ranges
        do {
            let range: ClosedRange<Version> = Version(1,0,0)...Version(1,1,0)
            XCTAssertTrue(range.contains(Version(1,0,0)))
            XCTAssertTrue(range.contains(Version(1,0,9)))
            XCTAssertTrue(range.contains(Version(1,1,0)))

            XCTAssertFalse(range.contains(Version(1,0,1, prereleaseIdentifiers: ["beta"])))
            XCTAssertFalse(range.contains(Version(1,0,10, prereleaseIdentifiers: ["clpha"])))
            XCTAssertFalse(range.contains(Version(1,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(1,2,0)))
            XCTAssertFalse(range.contains(Version(1,5,0)))
            XCTAssertFalse(range.contains(Version(2,0,0)))
            XCTAssertFalse(range.contains(Version(1,1,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(1,1,0, prereleaseIdentifiers: ["beta"])))
        }

        do {
            let range: ClosedRange<Version> = Version(1,0,0)...Version(1,1,0, prereleaseIdentifiers: ["alpha"])
            XCTAssertTrue(range.contains(Version(1,0,0)))
            XCTAssertTrue(range.contains(Version(1,0,9)))
            XCTAssertTrue(range.contains(Version(1,0,1, prereleaseIdentifiers: ["beta"])))
            XCTAssertTrue(range.contains(Version(1,0,10, prereleaseIdentifiers: ["clpha"])))
            XCTAssertTrue(range.contains(Version(1,1,0, prereleaseIdentifiers: ["alpha"])))

            XCTAssertFalse(range.contains(Version(1,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertFalse(range.contains(Version(1,1,0)))
            XCTAssertFalse(range.contains(Version(1,2,0)))
            XCTAssertFalse(range.contains(Version(1,5,0)))
            XCTAssertFalse(range.contains(Version(2,0,0)))
            XCTAssertFalse(range.contains(Version(1,1,0, prereleaseIdentifiers: ["beta"])))
            XCTAssertFalse(range.contains(Version(1,1,0, prereleaseIdentifiers: ["alphb"])))
        }

        do {
            let range: ClosedRange<Version> = Version(1,0,0, prereleaseIdentifiers: ["alpha"])...Version(1,1,0)

            XCTAssertTrue(range.contains(Version(1,0,9)))
            XCTAssertTrue(range.contains(Version(1,0,1, prereleaseIdentifiers: ["beta"])))
            XCTAssertTrue(range.contains(Version(1,0,10, prereleaseIdentifiers: ["clpha"])))
            XCTAssertTrue(range.contains(Version(1,0,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertTrue(range.contains(Version(1,1,0)))
            XCTAssertTrue(range.contains(Version(1,1,0, prereleaseIdentifiers: ["alpha"])))
            XCTAssertTrue(range.contains(Version(1,1,0, prereleaseIdentifiers: ["beta"])))
            XCTAssertTrue(range.contains(Version(1,0,0)))

            XCTAssertFalse(range.contains(Version(1,2,0)))
            XCTAssertFalse(range.contains(Version(1,5,0)))
            XCTAssertFalse(range.contains(Version(2,0,0)))
        }
    }

    func testAbsolute() {
        XCTAssertEqual(Version(-1,1,1), Version(1,1,1))
        XCTAssertEqual(Version(1,-1,1), Version(1,1,1))
        XCTAssertEqual(Version(1,1,-1), Version(1,1,1))
        XCTAssertEqual(Version(1,-1,-1), Version(1,1,1))
        XCTAssertEqual(Version(-1,-1,-1), Version(1,1,1))
    }

    func testInitializers() {
        let v1 = Version(1,0,0)
        let v2 = Version(major: 1, minor: 0, patch: 0)
        XCTAssertEqual(v1, v2)
    }

    func testTolerantIntiliazer() {
        XCTAssertEqual(Version(tolerant: "2.3-beta"), Version(2,3,0, prereleaseIdentifiers: ["beta"]))

        XCTAssertNil(Version(tolerant: "10..0.0"))
        XCTAssertNil(Version(tolerant: "10.0..0"))
        XCTAssertNil(Version(tolerant: "10.0.0."))
        XCTAssertNil(Version(tolerant: "10.0.0.."))
        XCTAssertNil(Version(tolerant: "10.0.0.0"))

        XCTAssertNil(Version(tolerant: "10.0.0.-1"))

        XCTAssertNil(Version(tolerant: "10beta"))
        XCTAssertNil(Version(tolerant: "10d"))
        XCTAssertNil(Version(tolerant: "10.-1"))

        XCTAssertNil(Version(tolerant: ""))
        XCTAssertNil(Version(tolerant: "1.2.3.4"))
        XCTAssertNil(Version(tolerant: "1.2.3.4.5"))
        XCTAssertNil(Version(tolerant: "a"))
        XCTAssertNil(Version(tolerant: "1.a"))
        XCTAssertNil(Version(tolerant: "a.2"))
        XCTAssertNil(Version(tolerant: "a.2.3"))
        XCTAssertNil(Version(tolerant: "1.a.3"))
        XCTAssertNil(Version(tolerant: "1.2.a"))
        XCTAssertNil(Version(tolerant: "-1.2.3"))
        XCTAssertNil(Version(tolerant: "1.-2.3"))
        XCTAssertNil(Version(tolerant: "1.2.-3"))
        XCTAssertNil(Version(tolerant: ".1.2.3"))
        XCTAssertNil(Version(tolerant: ".1.2"))
        XCTAssertNil(Version(tolerant: ".1"))
        XCTAssertNil(Version(tolerant: "v.1.2.3"))
        XCTAssertNil(Version(tolerant: "v.1.2"))
        XCTAssertNil(Version(tolerant: "v.1"))
        XCTAssertNil(Version(tolerant: "1.2..3"))

        XCTAssertNil(Version("1-beta1"))
        XCTAssertEqual(Version(tolerant: "1-beta1"), Version(1,0,0, prereleaseIdentifiers: ["beta1"]))
        XCTAssertNil(Version("1.0-beta1"))
        XCTAssertEqual(Version(tolerant: "1.0-beta1"), Version(1,0,0, prereleaseIdentifiers: ["beta1"]))

        XCTAssertEqual(Version(tolerant: "v1"), Version(1,0,0))
        XCTAssertEqual(Version(tolerant: "v1.0"), Version(1,0,0))
        XCTAssertEqual(Version(tolerant: "v1.0.0"), Version(1,0,0))
        XCTAssertEqual(Version(tolerant: "v1-beta1"), Version(1,0,0, prereleaseIdentifiers: ["beta1"]))
        XCTAssertEqual(Version(tolerant: "v1.0-beta1"), Version(1,0,0, prereleaseIdentifiers: ["beta1"]))
        XCTAssertEqual(Version(tolerant: "v1.0.0-beta1"), Version(1,0,0, prereleaseIdentifiers: ["beta1"]))
    }

    func testCodable() throws {
        let input = [Version.null]
        let data = try JSONEncoder().encode(input)
        let output = try JSONDecoder().decode([Version].self, from: data)
        XCTAssertEqual(input, output)

        XCTAssertEqual(String(data: data, encoding: .utf8), "[\"0.0.0\"]")

        let corruptData = try JSONEncoder().encode(["1.2.c"])
        XCTAssertThrowsError(try JSONDecoder().decode([Version].self, from: corruptData))
    }

    func testCodableWithTolerantInitializer() throws {
        let versionString = "1.2"
        let input = try JSONEncoder().encode([versionString])

        let encoder = JSONDecoder()
        XCTAssertThrowsError(try encoder.decode([Version].self, from: input))
        encoder.userInfo[.decodingMethod] = DecodingMethod.tolerant
        XCTAssertNoThrow(try encoder.decode([Version].self, from: input))
    }

    func testBundleExtension() {
        XCTAssertEqual(Bundle.main.version, .null)
    }

    func testProcessInfoExtension() {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        XCTAssertEqual(ProcessInfo.processInfo.osVersion, Version(v.majorVersion, v.minorVersion, v.patchVersion))
    }

    func testNegatives() {
        XCTAssertEqual(Version(-1,-2,-3), Version(1,2,3))
    }

    func testStringProtocol() {
      #if compiler(>=5)
        XCTAssertEqual(Version(".1.2.3".dropFirst()), Version(1,2,3))
      #endif
    }
}
