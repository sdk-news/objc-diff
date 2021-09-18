// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "sdk-diff",
    platforms: [
        .macOS(.v10_12),
    ],
    products: [
        .executable(name: "ocdiff", targets: ["ocdiff"]),
    ],
    dependencies: [
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .branch("release/5.4")),
    ],
    targets: [
        .target(
            name: "ocdiff",
            dependencies: ["OCDiffCore", "OCDiffCoreObjC", "OCDiffReporting"],
            cSettings: [
                .frameworkSearchPath("Dependencies"),
            ],
            linkerSettings: [
                .linkedFramework("ObjectDoc"),
                .frameworkSearchPath("Dependencies"),
                .runpathSearchPath(URL.packageRoot.appendingPathComponent("Dependencies"), .when(configuration: .debug)),
            ]
        ),

        .target(
            name: "OCDiffCore",
            dependencies: [],
            publicHeadersPath: ""
        ),

        .target(
            name: "OCDiffCoreObjC",
            dependencies: ["OCDiffCore"],
            publicHeadersPath: "",
            cSettings: [
                .frameworkSearchPath("Dependencies"),
            ],
            linkerSettings: [
                .linkedFramework("ObjectDoc"),
                .frameworkSearchPath("Dependencies"),
            ]
        ),
        .testTarget(
            name: "OCDiffCoreObjCTests",
            dependencies: ["OCDiffCoreObjC"],
            cSettings: [
                .frameworkSearchPath("Dependencies"),
            ],
            linkerSettings: [
                .frameworkSearchPath("Dependencies"),
                .runpathSearchPath(URL.packageRoot.appendingPathComponent("Dependencies"), .when(configuration: .debug)),
            ]
        ),

        .target(
            name: "OCDiffReporting",
            dependencies: ["OCDiffCore"],
            resources: [
              .copy("apidiff.css"),
            ],
            publicHeadersPath: "",
            cSettings: [
                .frameworkSearchPath("Dependencies"),
            ],
            linkerSettings: [
                .frameworkSearchPath("Dependencies"),
            ]
        ),
        .testTarget(
            name: "OCDiffReportingTests",
            dependencies: ["OCDiffReporting"],
            resources: [
              .copy("SDKs"),
            ],
            cSettings: [
                .frameworkSearchPath("Dependencies"),
            ],
            linkerSettings: [
                .frameworkSearchPath("Dependencies"),
                .runpathSearchPath(URL.packageRoot.appendingPathComponent("Dependencies"), .when(configuration: .debug)),
            ]
        ),
    ]
)

// MARK: - Utilities

extension URL {
    static let packageRoot = URL(fileURLWithPath: #file).deletingLastPathComponent()
}

extension CSetting {
    static func frameworkSearchPath(_ path: String, _ condition: BuildSettingCondition? = nil) -> CSetting {
        return .unsafeFlags(["-F", path], condition)
    }
}

extension SwiftSetting {
    static func frameworkSearchPath(_ path: String, _ condition: BuildSettingCondition? = nil) -> SwiftSetting {
        return .unsafeFlags(["-F", path], condition)
    }
}

extension LinkerSetting {
    static func frameworkSearchPath(_ path: String, _ condition: BuildSettingCondition? = nil) -> LinkerSetting {
        return .unsafeFlagsFix(["-F" + path], condition)
    }

    static func runpathSearchPath(_ path: String, _ condition: BuildSettingCondition? = nil) -> LinkerSetting {
        return .unsafeFlagsFix(["-rpath", path], condition)
    }

    static func runpathSearchPath(_ url: URL, _ condition: BuildSettingCondition? = nil) -> LinkerSetting {
        precondition(url.isFileURL)
        return .runpathSearchPath(url.path, condition)
    }

    private static func unsafeFlagsFix(_ flags: [String], _ condition: BuildSettingCondition? = nil) -> LinkerSetting {
        return .unsafeFlags(flags.flatMap({ ["-Xlinker", $0] }), condition)
    }
}
