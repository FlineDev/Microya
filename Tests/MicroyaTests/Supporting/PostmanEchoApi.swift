#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import Microya
import XCTest

enum PostmanEchoApi {
    // Endpoints
    case index(sortedBy: String)
    case post(fooBar: FooBar)
    case get(fooBarID: String)
    case patch(fooBarID: String, fooBar: FooBar)
    case delete(fooBarID: String)

    // Plugins
    static let basicAuthPlugin = HttpBasicAuthPlugin<Self>(tokenClosure: { "abc123" })
    static let requestLoggerPlugin = RequestLoggerPlugin<Self>(logClosure: { TestDataStore.request = $0 })
    static let responseLoggerPlugin = ResponseLoggerPlugin<Self>(logClosure: { TestDataStore.urlSessionResult = $0 })
    static let progressIndicatorPlugin = ProgressIndicatorPlugin<Self>(
        showIndicator: { TestDataStore.showingProgressIndicator = true },
        hideIndicator: { TestDataStore.showingProgressIndicator = false }
    )
}

extension PostmanEchoApi: JsonApi {
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

    var plugins: [Plugin<Self>] {
        var plugins: [Plugin<Self>] = [Self.requestLoggerPlugin, Self.responseLoggerPlugin]

        switch self {
        case .index:
            break

        case .get:
            plugins.append(Self.progressIndicatorPlugin)

        case .post, .patch, .delete:
            plugins.append(Self.basicAuthPlugin)
        }

        return plugins
    }

    var baseUrl: URL {
        URL(string: "https://postman-echo.com")!
    }

    var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": Locale.current.languageCode ?? "en"
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

        case let .delete(fooBarID):
            return "delete/\(fooBarID)"
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

    var queryParameters: [String: String] {
        switch self {
        case let .index(sortedBy):
            return ["sortedBy": sortedBy]

        default:
            return [:]
        }
    }
}
