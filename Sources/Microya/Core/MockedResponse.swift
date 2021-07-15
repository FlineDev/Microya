import Foundation

/// The mocked response to use for testing purposes.
public struct MockedResponse {
  /// The status code to be returned for the mocked response.
  public let statusCode: Int

  /// The headers to return as part of the mocked response.
  public let headers: [String: String]

  /// The body to return as JSON data for the mocked response. Provided JSON string will be converted to data using `.utf8` formatting.
  public let bodyJson: String?

  /// Initializes a mocked response for testing purposes. Requires at least a status code. Headers and body are optional.
  public init(statusCode: Int, headers: [String: String] = [:], bodyJson: String? = nil) {
    self.statusCode = statusCode
    self.headers = headers
    self.bodyJson = bodyJson
  }

  var bodyData: Data? {
    bodyJson?.data(using: .utf8)
  }
}
