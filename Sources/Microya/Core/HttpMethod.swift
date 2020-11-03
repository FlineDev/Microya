import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// The relevant HTTP request methods defined in the HTTP standard.
public enum HttpMethod {
    /// The GET HTTP method.
    case get

    /// The POST HTTP method. Required body data to be sent.
    case post(body: Data)

    /// The PATCH HTTP method. Required body data to be sent.
    case patch(body: Data)

    /// The DELETE HTTP method.
    case delete

    func apply(to request: inout URLRequest) {
        switch self {
        case .get:
            request.httpMethod = "GET"

        case let .post(body):
            request.httpMethod = "POST"
            request.httpBody = body

        case let .patch(body):
            request.httpMethod = "PATCH"
            request.httpBody = body

        case .delete:
            request.httpMethod = "DELETE"
        }
    }
}
