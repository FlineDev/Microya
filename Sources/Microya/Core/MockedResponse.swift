import Foundation

/// The mocked response to use for testing purposes.
public struct MockedResponse: Equatable {
  /// The subpath to be added to the base URL.
  public let subpath: String

  /// The status code to be returned for the mocked response.
  public let statusCode: Int

  /// The headers to return as part of the mocked response.
  public let headers: [String: String]

  /// The body JSON converted to Data using `.utf8` formatting or `nil` if empty.
  public let bodyData: Data?

  /// Initializes a mocked response for testing purposes. Requires at least a status code. Headers and body are optional.
  ///
  /// Consider using the convenience `.mock` factory method in the `Endpoint` type instead,  which will detect the `subpath` automatically.
  /// Provided JSON string will be converted to data using `.utf8` formatting.
  public init(
    subpath: String,
    statusCode: Int,
    bodyJson: String? = nil,
    headers: [String: String] = [:]
  ) {
    self.subpath = subpath
    self.statusCode = statusCode
    self.bodyData = bodyJson?.data(using: .utf8)
    self.headers = headers
  }

  /// Initializes a mocked response for testing purposes. Requires at least a status code. Headers and body are optional.
  ///
  /// Consider using the convenience `.mock` factory method in the `Endpoint` type instead,  which will detect the `subpath` automatically.
  public init(
    subpath: String,
    statusCode: Int,
    bodyData: Data,
    headers: [String: String] = [:]
  ) {
    self.subpath = subpath
    self.statusCode = statusCode
    self.bodyData = bodyData
    self.headers = headers
  }

  func url(baseUrl: URL) -> URL {
    baseUrl.appendingPathComponent(subpath)
  }

  func httpUrlResponse(baseUrl: URL) -> HTTPURLResponse {
    .init(
      url: url(baseUrl: baseUrl),
      statusCode: statusCode,
      httpVersion: "HTTP/1.1",
      headerFields: headers
    )!
  }
}
