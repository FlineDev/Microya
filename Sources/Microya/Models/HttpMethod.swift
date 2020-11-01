import Foundation

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
}
