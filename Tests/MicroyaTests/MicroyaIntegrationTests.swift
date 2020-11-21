#if canImport(Combine)
  import Combine
#endif
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
@testable import Microya
import XCTest

class MicroyaIntegrationTests: XCTestCase {
  private let fooBarID: String = "aBcDeF012-gHiJkLMnOpQ3456-RsTuVwXyZ789"

  override func setUpWithError() throws {
    try super.setUpWithError()

    #if canImport(Combine)
      cancellables = []
    #endif

    TestDataStore.reset()
  }

  func testIndex() throws {
    let typedResponseBody =
      try sampleApiProvider.performRequestAndWait(
        on: .index(sortedBy: "updatedAt"),
        decodeBodyTo: PostmanEchoResponse.self
      )
      .get()

    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

    XCTAssertEqual(TestDataStore.request?.httpMethod, "GET")
    XCTAssertEqual(TestDataStore.request?.url?.path, "/get")
    XCTAssertEqual(TestDataStore.request?.url?.query, "sortedBy=updatedAt")

    XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
    XCTAssertNil(TestDataStore.urlSessionResult?.error)
    XCTAssertNotNil(TestDataStore.urlSessionResult?.response)

    XCTAssertEqual(typedResponseBody.args, ["sortedBy": "updatedAt"])
    XCTAssertEqual(typedResponseBody.headers["content-type"], "application/json")
    XCTAssertEqual(typedResponseBody.headers["accept"], "application/json")
    XCTAssertEqual(typedResponseBody.headers["accept-language"], "en")
    XCTAssertEqual(typedResponseBody.url, "https://postman-echo.com/get?sortedBy=updatedAt")
  }

  func testPost() throws {
    let typedResponseBody =
      try sampleApiProvider.performRequestAndWait(
        on: .post(fooBar: FooBar(foo: "Lorem", bar: "Ipsum")),
        decodeBodyTo: PostmanEchoResponse.self
      )
      .get()

    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

    XCTAssertEqual(TestDataStore.request?.httpMethod, "POST")
    XCTAssertEqual(TestDataStore.request?.url?.path, "/post")
    XCTAssertNil(TestDataStore.request?.url?.query)

    XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
    XCTAssertNil(TestDataStore.urlSessionResult?.error)
    XCTAssertNotNil(TestDataStore.urlSessionResult?.response)

    XCTAssertEqual(typedResponseBody.args, [:])
    XCTAssertEqual(typedResponseBody.headers["content-type"], "application/json")
    XCTAssertEqual(typedResponseBody.headers["accept"], "application/json")
    XCTAssertEqual(typedResponseBody.headers["accept-language"], "en")
    XCTAssertEqual(typedResponseBody.url, "https://postman-echo.com/post")
  }

  func testGet() throws {
    let expectation = XCTestExpectation()

    XCTAssertFalse(TestDataStore.showingProgressIndicator)

    sampleApiProvider.performRequest(on: .get(fooBarID: fooBarID), decodeBodyTo: PostmanEchoResponse.self) { result in
      switch result {
      case .success:
        XCTFail("Expected to receive error due to missing endpoint path.")

      default:
        break
      }

      expectation.fulfill()
    }

    XCTAssertTrue(TestDataStore.showingProgressIndicator)
    wait(for: [expectation], timeout: 10)
    XCTAssertFalse(TestDataStore.showingProgressIndicator)

    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

    XCTAssertEqual(TestDataStore.request?.httpMethod, "GET")
    XCTAssertEqual(TestDataStore.request?.url?.path, "/get/\(fooBarID)")
    XCTAssertNil(TestDataStore.request?.url?.query)
  }

  func testPatch() throws {
    XCTAssertThrowsError(
      try sampleApiProvider.performRequestAndWait(
        on: .patch(fooBarID: fooBarID, fooBar: FooBar(foo: "Dolor", bar: "Amet")),
        decodeBodyTo: PostmanEchoResponse.self
      )
      .get()
    )

    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

    XCTAssertEqual(TestDataStore.request?.httpMethod, "PATCH")
    XCTAssertEqual(TestDataStore.request?.url?.path, "/patch/\(fooBarID)")
    XCTAssertNil(TestDataStore.request?.url?.query)

    XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
    XCTAssertNil(TestDataStore.urlSessionResult?.error)
    XCTAssertNotNil(TestDataStore.urlSessionResult?.response)
  }

  func testDelete() throws {
    let result = sampleApiProvider.performRequestAndWait(on: .delete)

    switch result {
    case .success:
      break

    default:
      XCTFail("Expected request to succeed.")
    }

    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
    XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

    XCTAssertEqual(TestDataStore.request?.httpMethod, "DELETE")
    XCTAssertEqual(TestDataStore.request?.url?.path, "/delete")
    XCTAssertNil(TestDataStore.request?.url?.query)

    XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
    XCTAssertNil(TestDataStore.urlSessionResult?.error)
    XCTAssertNotNil(TestDataStore.urlSessionResult?.response)
  }

  #if canImport(Combine)
    var cancellables: Set<AnyCancellable>!

    func testIndexCombine() throws {
      let expectation = XCTestExpectation()

      sampleApiProvider.publisher(
        on: .index(sortedBy: "updatedAt"),
        decodeBodyTo: PostmanEchoResponse.self
      )
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { typedResponseBody in
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

          XCTAssertEqual(TestDataStore.request?.httpMethod, "GET")
          XCTAssertEqual(TestDataStore.request?.url?.path, "/get")
          XCTAssertEqual(TestDataStore.request?.url?.query, "sortedBy=updatedAt")

          XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
          XCTAssertNil(TestDataStore.urlSessionResult?.error)
          XCTAssertNotNil(TestDataStore.urlSessionResult?.response)

          XCTAssertEqual(typedResponseBody.args, ["sortedBy": "updatedAt"])
          XCTAssertEqual(typedResponseBody.headers["content-type"], "application/json")
          XCTAssertEqual(typedResponseBody.headers["accept"], "application/json")
          XCTAssertEqual(typedResponseBody.headers["accept-language"], "en")
          XCTAssertEqual(typedResponseBody.url, "https://postman-echo.com/get?sortedBy=updatedAt")

          expectation.fulfill()
        }
      )
      .store(in: &cancellables)

      wait(for: [expectation], timeout: 10)
    }

    func testPostCombine() throws {
      let expectation = XCTestExpectation()

      sampleApiProvider.publisher(
        on: .post(fooBar: FooBar(foo: "Lorem", bar: "Ipsum")),
        decodeBodyTo: PostmanEchoResponse.self
      )
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { typedResponseBody in
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

          XCTAssertEqual(TestDataStore.request?.httpMethod, "POST")
          XCTAssertEqual(TestDataStore.request?.url?.path, "/post")
          XCTAssertNil(TestDataStore.request?.url?.query)

          XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
          XCTAssertNil(TestDataStore.urlSessionResult?.error)
          XCTAssertNotNil(TestDataStore.urlSessionResult?.response)

          XCTAssertEqual(typedResponseBody.args, [:])
          XCTAssertEqual(typedResponseBody.headers["content-type"], "application/json")
          XCTAssertEqual(typedResponseBody.headers["accept"], "application/json")
          XCTAssertEqual(typedResponseBody.headers["accept-language"], "en")
          XCTAssertEqual(typedResponseBody.url, "https://postman-echo.com/post")

          expectation.fulfill()
        }
      )
      .store(in: &cancellables)

      wait(for: [expectation], timeout: 10)
    }

    func testGetCombine() throws {
      let expectation = XCTestExpectation()

      XCTAssertFalse(TestDataStore.showingProgressIndicator)

      sampleApiProvider.publisher(on: .get(fooBarID: fooBarID), decodeBodyTo: PostmanEchoResponse.self)
        .sink(
          receiveCompletion: { _ in

            XCTAssertFalse(TestDataStore.showingProgressIndicator)

            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

            XCTAssertEqual(TestDataStore.request?.httpMethod, "GET")
            XCTAssertEqual(TestDataStore.request?.url?.path, "/get/\(self.fooBarID)")
            XCTAssertNil(TestDataStore.request?.url?.query)

            expectation.fulfill()
          },
          receiveValue: { typedResponseBody in
            XCTFail("Expected to receive error due to missing endpoint path.")

            expectation.fulfill()
          }
        )
        .store(in: &cancellables)

      XCTAssertTrue(TestDataStore.showingProgressIndicator)
      wait(for: [expectation], timeout: 10)
    }

    func testPatchCombine() throws {
      let expectation = XCTestExpectation()

      sampleApiProvider.publisher(
        on: .patch(fooBarID: fooBarID, fooBar: FooBar(foo: "Dolor", bar: "Amet")),
        decodeBodyTo: PostmanEchoResponse.self
      )
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case let .failure(.clientError(statusCode, clientError)):
            XCTAssertEqual(statusCode, 404)
            XCTAssertNil(clientError)

          default:
            XCTFail("Expected to receive a 404 API error.")
          }
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
          XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

          XCTAssertEqual(TestDataStore.request?.httpMethod, "PATCH")
          XCTAssertEqual(TestDataStore.request?.url?.path, "/patch/\(self.fooBarID)")
          XCTAssertNil(TestDataStore.request?.url?.query)

          XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
          XCTAssertNil(TestDataStore.urlSessionResult?.error)
          XCTAssertNotNil(TestDataStore.urlSessionResult?.response)

          expectation.fulfill()
        },
        receiveValue: { typedResponseBody in
          XCTFail("Expected call to throw an error.")
        }
      )
      .store(in: &cancellables)

      wait(for: [expectation], timeout: 10)
    }

    func testDeleteCombine() throws {
      let expectation = XCTestExpectation()

      sampleApiProvider.publisher(on: .delete)
        .sink(
          receiveCompletion: { _ in },
          receiveValue: { typedResponseBody in

            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
            XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], "Basic abc123")

            XCTAssertEqual(TestDataStore.request?.httpMethod, "DELETE")
            XCTAssertEqual(TestDataStore.request?.url?.path, "/delete")
            XCTAssertNil(TestDataStore.request?.url?.query)

            XCTAssertNotNil(TestDataStore.urlSessionResult?.data)
            XCTAssertNil(TestDataStore.urlSessionResult?.error)
            XCTAssertNotNil(TestDataStore.urlSessionResult?.response)

            expectation.fulfill()
          }
        )
        .store(in: &cancellables)

      wait(for: [expectation], timeout: 10)
    }
  #endif
}
