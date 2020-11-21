// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@testable import MicroyaTests
import XCTest

extension MicroyaIntegrationTests {
  static var allTests: [(String, (MicroyaIntegrationTests) -> () throws -> Void)] = [
    ("testIndex", testIndex),
    ("testPost", testPost),
    ("testGet", testGet),
    ("testPatch", testPatch),
    ("testDelete", testDelete),
  ]
}

XCTMain([
  testCase(MicroyaIntegrationTests.allTests)
])
