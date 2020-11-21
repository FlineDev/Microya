import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// Helper type for request where no body is expected as part of the response.
public struct EmptyBodyResponse: Decodable { /* no body needed */  }

/// The protocol which defines the structure of an API endpoint.
public protocol Endpoint {
  /// The error body type the server responds with for any client errors.
  associatedtype ClientErrorType: Decodable

  /// The JSON decoder to be used for decoding.
  var decoder: JSONDecoder { get }

  /// The JSON encoder to be used for encoding.
  var encoder: JSONEncoder { get }

  /// The common base URL of the API endpoints.
  var baseUrl: URL { get }

  /// The headers to be sent per request.
  var headers: [String: String] { get }

  /// The subpath to be added to the base URL.
  var subpath: String { get }

  /// The HTTP method to be used for the request.
  var method: HttpMethod { get }

  /// The URL query parameters to be sent (part after ? in URLs, e.g. google.com?query=Harry+Potter).
  var queryParameters: [String: QueryParameterValue] { get }
}

extension Endpoint {
  func buildRequest() -> URLRequest {
    var request = URLRequest(url: buildRequestUrl())

    method.apply(to: &request)

    for (field, value) in headers {
      request.setValue(value, forHTTPHeaderField: field)
    }

    return request
  }

  private func buildRequestUrl() -> URL {
    var urlComponents = URLComponents(
      url: baseUrl.appendingPathComponent(subpath),
      resolvingAgainstBaseURL: false
    )!

    if !queryParameters.isEmpty {
      urlComponents.queryItems = []
      for (key, value) in queryParameters {
        for stringValue in value.values {
          urlComponents.queryItems?.append(URLQueryItem(name: key, value: stringValue))
        }
      }
    }

    return urlComponents.url!
  }
}

// Provide sensible default to effectively make some of the protocol requirements optional.
extension Endpoint {
  public var decoder: JSONDecoder {
    JSONDecoder()
  }

  public var encoder: JSONEncoder {
    JSONEncoder()
  }

  public var plugins: [Plugin<Self>] {
    []
  }

  public var headers: [String: String] {
    [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Accept-Language": Locale.current.languageCode ?? "en",
    ]
  }

  public var queryParameters: [String: QueryParameterValue] {
    [:]
  }
}
