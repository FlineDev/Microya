#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import Microya
import XCTest

class MicroyaIntegrationTests: XCTestCase {
    private let fooBarID: String = "aBcDeF012-gHiJkLMnOpQ3456-RsTuVwXyZ789"

    override func setUpWithError() throws {
        try super.setUpWithError()

        TestDataStore.reset()
    }

    func testIndex() throws {
        let typedResponseBody = try PostmanEchoApi
            .index(sortedBy: "updatedAt")
            .performRequestAndWait(decodeBodyTo: PostmanEchoResponse.self).get()

        XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Accept-Language"], "en")
        XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], nil)

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
        let typedResponseBody = try PostmanEchoApi
            .post(fooBar: FooBar(foo: "Lorem", bar: "Ipsum"))
            .performRequestAndWait(decodeBodyTo: PostmanEchoResponse.self).get()

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

        PostmanEchoApi
            .get(fooBarID: fooBarID)
            .performRequest(decodeBodyTo: PostmanEchoResponse.self) { result in
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
        XCTAssertEqual(TestDataStore.request?.allHTTPHeaderFields?["Authorization"], nil)

        XCTAssertEqual(TestDataStore.request?.httpMethod, "GET")
        XCTAssertEqual(TestDataStore.request?.url?.path, "/get/\(fooBarID)")
        XCTAssertNil(TestDataStore.request?.url?.query)
    }

    func testPatch() throws {
        XCTAssertThrowsError(
            try PostmanEchoApi
                .patch(fooBarID: fooBarID, fooBar: FooBar(foo: "Dolor", bar: "Amet"))
                .performRequestAndWait(decodeBodyTo: PostmanEchoResponse.self).get()
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
        let result = PostmanEchoApi.delete.performRequestAndWait()

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
}
