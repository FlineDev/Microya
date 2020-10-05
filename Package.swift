// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Microya",
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
