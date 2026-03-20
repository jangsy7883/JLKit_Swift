// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "JLKit_Swift",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "JLKit_Swift",
            targets: ["JLKit_Swift"]
        )
    ],
    targets: [
        .target(
            name: "JLKit_Swift",
            dependencies: [],
            path: "JLKit",
            sources: [
                "Extensions/Foundation",
                "Extensions/UIKit",
                "Extensions/SwiftStdlib",
                "Protocols",
                "Utils"
            ],
            linkerSettings: [
                .linkedFramework("Photos", .when(platforms: [.iOS]))
            ]
        )
    ]
)
