// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "Microya",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
  products: [
    .library(name: "Microya", targets: ["Microya"])
  ],
  dependencies: [
    // ⏰ A few schedulers that make working with Combine more testable and more versatile.
    .package(url: "https://github.com/pointfreeco/combine-schedulers.git", from: "0.5.0")
  ],
  targets: [
    .target(
      name: "Microya",
      dependencies: [
        .product(name: "CombineSchedulers", package: "combine-schedulers")
      ]
    ),
    .testTarget(
      name: "MicroyaTests",
      dependencies: ["Microya"]
    ),
  ]
)
