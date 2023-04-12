#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import Microya
import XCTest

class EndpointTests: XCTestCase {
   enum TestEndpoint: Endpoint {
      case test

      typealias ClientErrorType = EmptyBodyResponse
      var subpath: String { return "" }
      var method: Microya.HttpMethod { return .get }
   }

   func testPostQueryItemsToWwwUrlEncode_ampersandInValue() {
      let method = TestEndpoint.test.post(
         queryItemsToWwwUrlEncode: [
            URLQueryItem(name: "source_lang", value: "EN"),
            URLQueryItem(name: "target_lang", value: "FR"),
            URLQueryItem(name: "text", value: "Hello & Goodbye"),
         ]
      )

      switch method {
      case .post(let bodyData):
         XCTAssertNotNil(bodyData)

         let bodyString = String(data: bodyData!, encoding: .utf8)
         XCTAssertEqual("source_lang=EN&target_lang=FR&text=Hello%20%26%20Goodbye", bodyString)

      default:
         XCTFail("Expected to get a `.post` method back when calling `.post`.")
      }
   }
}
