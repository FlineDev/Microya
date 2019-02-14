// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Microya",
    products: [
        .library(name: "Microya", targets: ["Microya"])
    ],
    dependencies: [
//        .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.5.0")),
//        .package(url: "https://github.com/Flinesoft/HandyUIKit.git", .upToNextMajor(from: "1.6.0"))
    ],
    targets: [
        .target(
            name: "Microya",
            dependencies: [
//                "HandySwift",
//                "HandyUIKit"
            ],
            path: "Frameworks/Microya",
            exclude: ["Frameworks/SupportingFiles"]
        ),
        .testTarget(
            name: "MicroyaTests",
            dependencies: ["Microya"],
            exclude: ["Tests/SupportingFiles"]
        )
    ]
)
