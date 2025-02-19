// swift-tools-version:5.7.1

import PackageDescription

let package = Package(
    name: "RollbarNotifier",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "RollbarNotifier",
            targets: [
                "RollbarCrash",
                "RollbarReport",
                "RollbarNotifier"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../RollbarCommon"),
        .package(path: "../UnitTesting"),
    ],
    targets: [
        .target(
            name: "RollbarCrash",
            dependencies: [],
            path: "Sources/RollbarCrash",
            cxxSettings: [
                .define("GCC_ENABLE_CPP_EXCEPTIONS", to: "YES"),
                .headerSearchPath("Monitors"),
                .headerSearchPath("Recording"),
                .headerSearchPath("Util"),
            ],
            linkerSettings: [
                .linkedLibrary("c++"),
                .linkedLibrary("z")
            ]
        ),
        .target(
            name: "RollbarReport",
            dependencies: ["RollbarCrash"],
            path: "Sources/RollbarReport"
        ),
        .target(
            name: "RollbarNotifier",
            dependencies: [
                "RollbarCommon",
                "RollbarCrash",
                "RollbarReport"
            ],
            path: "Sources/RollbarNotifier"
        ),
        .testTarget(
            name: "RollbarReportTests",
            dependencies: ["RollbarReport"],
            resources: [.process("Assets")]
        ),
        .testTarget(
            name: "RollbarNotifierTests",
            dependencies: [
                "UnitTesting",
                "RollbarNotifier"
            ]
        ),
        .testTarget(
            name: "RollbarNotifierTests-ObjC",
            dependencies: [
                "UnitTesting",
                "RollbarNotifier",
            ],
            path: "Tests/RollbarNotifierTests-ObjC"
        ),
    ],
    swiftLanguageVersions: [
        SwiftVersion.v5
    ],
    cxxLanguageStandard: .cxx17
)
