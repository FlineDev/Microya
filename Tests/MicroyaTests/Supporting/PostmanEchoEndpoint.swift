#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
@testable import Microya
import XCTest
import CombineSchedulers

let sampleApiProvider = ApiProvider<PostmanEchoEndpoint>(
  baseUrl: URL(string: "https://postman-echo.com")!,
  plugins: [
    HttpBasicAuthPlugin<PostmanEchoEndpoint>(tokenClosure: { "abc123" }),
    RequestLoggerPlugin<PostmanEchoEndpoint>(logClosure: { TestDataStore.request = $0 }),
    ResponseLoggerPlugin<PostmanEchoEndpoint>(logClosure: { TestDataStore.urlSessionResult = $0 }),
    ProgressIndicatorPlugin<PostmanEchoEndpoint>(
      showIndicator: { TestDataStore.showingProgressIndicator = true },
      hideIndicator: { TestDataStore.showingProgressIndicator = false }
    ),
  ]
)

let mockedApiProvider = ApiProvider<PostmanEchoEndpoint>(
  baseUrl: URL(string: "https://postman-echo.com")!,
  plugins: [
    HttpBasicAuthPlugin<PostmanEchoEndpoint>(tokenClosure: { "abc123" }),
    RequestLoggerPlugin<PostmanEchoEndpoint>(logClosure: { TestDataStore.request = $0 }),
    ResponseLoggerPlugin<PostmanEchoEndpoint>(logClosure: { TestDataStore.urlSessionResult = $0 }),
    ProgressIndicatorPlugin<PostmanEchoEndpoint>(
      showIndicator: { TestDataStore.showingProgressIndicator = true },
      hideIndicator: { TestDataStore.showingProgressIndicator = false }
    ),
  ],
  mockingBehavior: MockingBehavior(delay: .seconds(0.2), scheduler: DispatchQueue.main.eraseToAnyScheduler())
)

enum PostmanEchoEndpoint {
  // Endpoints
  case index(sortedBy: String)
  case post(fooBar: FooBar)
  case get(fooBarID: String)
  case patch(fooBarID: String, fooBar: FooBar)
  case delete
}

extension PostmanEchoEndpoint: Endpoint {
  typealias ClientErrorType = PostmanEchoError

  var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }

  var encoder: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
  }

  var headers: [String: String] {
    [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Accept-Language": Locale.current.languageCode ?? "en",
    ]
  }

  var subpath: String {
    switch self {
    case .index:
      return "get"

    case let .get(fooBarID):
      return "get/\(fooBarID)"

    case .post:
      return "post"

    case let .patch(fooBarID, _):
      return "patch/\(fooBarID)"

    case .delete:
      return "delete"
    }
  }

  var method: HttpMethod {
    switch self {
    case .index, .get:
      return .get

    case let .post(fooBar):
      return .post(body: try! encoder.encode(fooBar))

    case let .patch(_, fooBar):
      return .patch(body: try! encoder.encode(fooBar))

    case .delete:
      return .delete
    }
  }

  var queryParameters: [String: QueryParameterValue] {
    switch self {
    case let .index(sortedBy):
      return ["sortedBy": .string(sortedBy)]

    default:
      return [:]
    }
  }

  var mockedResponse: MockedResponse? {
    switch self {
    case let .get(fooBarID):
      return try! mock(
        status: .ok,
        bodyEncodable: FooBar(foo: "foo\(fooBarID)", bar: "bar\(fooBarID)")
      )

    case .delete:
      return mock(status: .noContent)

    default:
      return nil
    }
  }
}
