// swift-tools-version:5.4
import PackageDescription

let package = Package(
  name: "Microya",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
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

#if swift(>=5.6)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(url: “https://github.com/apple/swift-docc-plugin“, from: “1.0.0“)
  )
#endif
