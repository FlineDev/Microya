// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Microya",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: [
        .library(name: "Microya", targets: ["Microya"])
    ],
    targets: [
        .target(name: "Microya"),
        .testTarget(
            name: "MicroyaTests",
            dependencies: ["Microya"]
        )
    ]
)
