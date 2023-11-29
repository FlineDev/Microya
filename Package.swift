// swift-tools-version:5.8
import PackageDescription

let swiftSettings: [SwiftSetting] = [
   .enableUpcomingFeature("BareSlashRegexLiterals"),
   .enableUpcomingFeature("ConciseMagicFile"),
   .enableUpcomingFeature("ExistentialAny"),
   .enableUpcomingFeature("ForwardTrailingClosures"),
   .enableUpcomingFeature("ImplicitOpenExistentials"),
   .enableUpcomingFeature("StrictConcurrency"),
   .unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"]),
]

let package = Package(
   name: "Microya",
   platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
   products: [
      .library(name: "Microya", targets: ["Microya"])
   ],
   dependencies: [
      // ⏰ A few schedulers that make working with Combine more testable and more versatile.
      .package(url: "https://github.com/pointfreeco/combine-schedulers.git", from: "1.0.0")
   ],
   targets: [
      .target(
         name: "Microya",
         dependencies: [
            .product(name: "CombineSchedulers", package: "combine-schedulers")
         ],
         swiftSettings: swiftSettings
      ),
      .testTarget(
         name: "MicroyaTests",
         dependencies: ["Microya"],
         swiftSettings: swiftSettings
      ),
   ]
)
