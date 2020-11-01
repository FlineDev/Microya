@testable import Microya
import XCTest

class MicroyaIntegrationTests: XCTestCase {
    func testIndex() throws {
        let indexResponse: PostmanEchoResponse = try PostmanEchoApi.index(sortedBy: "updatedAt").performRequestAndWait().get()

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

        XCTAssertEqual(indexResponse.args, ["sortedBy": "updatedAt"])
        XCTAssertEqual(indexResponse.headers["content-type"], "application/json")
        XCTAssertEqual(indexResponse.headers["accept"], "application/json")
        XCTAssertEqual(indexResponse.headers["accept-language"], "en")
        XCTAssertEqual(indexResponse.url, "https://postman-echo.com/get?sortedBy=updatedAt")
    }
}
