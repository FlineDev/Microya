import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Helper type for request where no body is expected as part of the response.
public struct EmptyBodyResponse: Decodable, Equatable { /* no body needed */  }

/// The protocol which defines the structure of an API endpoint.
public protocol Endpoint {
   /// The error body type the server responds with for any client errors.
   associatedtype ClientErrorType: Decodable
   
   /// The JSON decoder to be used for decoding.
   var decoder: JSONDecoder { get }
   
   /// The JSON encoder to be used for encoding.
   var encoder: JSONEncoder { get }
   
   /// The headers to be sent per request.
   var headers: [String: String] { get }
   
   /// The subpath to be added to the base URL.
   var subpath: String { get }
   
   /// The HTTP method to be used for the request.
   var method: HttpMethod { get }
   
   /// The URL query parameters to be sent (part after ? in URLs, e.g. google.com?query=Harry+Potter).
   var queryParameters: [String: QueryParameterValue] { get }
   
   /// The mocked response for testing purposes. Will be returned instead of making actual calls when `ApiProvider`s `mockingBehavior` is set.
   var mockedResponse: MockedResponse? { get }
}

extension Endpoint {
   func buildRequest(baseUrl: URL) -> URLRequest {
      var request = URLRequest(url: buildRequestUrl(baseUrl: baseUrl))
      
      method.apply(to: &request)
      
      for (field, value) in headers {
         request.setValue(value, forHTTPHeaderField: field)
      }
      
      return request
   }
   
   private func buildRequestUrl(baseUrl: URL) -> URL {
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
   
   public var mockedResponse: MockedResponse? {
      nil
   }

   #warning("🧑‍💻 explore if such a thing is possible to auto-decode to the expected type")
//   public var successResponseType: (any Decodable.Type) {
//      EmptyBodyResponse.self
//   }
   
   /// Creates a `MockedResponse` object with the given status, body JSON string (optional) and headers (optional).
   public func mock(status: HttpStatus, bodyJson: String? = nil, headers: [String: String] = [:]) -> MockedResponse {
      MockedResponse(subpath: subpath, statusCode: status.code, bodyJson: bodyJson, headers: headers)
   }
   
   /// Creates a `MockedResponse` object with the given status, body `Encodable` object and headers (optional).
   public func mock<T: Encodable>(
      status: HttpStatus,
      bodyEncodable: T,
      headers: [String: String] = [:]
   ) throws -> MockedResponse {
      MockedResponse(
         subpath: subpath,
         statusCode: status.code,
         bodyData: try encoder.encode(bodyEncodable),
         headers: headers
      )
   }
}

extension Endpoint {
   public func post(encodable: some Encodable) throws -> HttpMethod {
      let encodedData = try self.encoder.encode(encodable)
      return .post(body: encodedData)
   }
   
   public func patch(encodable: some Encodable) throws -> HttpMethod {
      let encodedData = try self.encoder.encode(encodable)
      return .patch(body: encodedData)
   }
   
   public func post(dictToWwwUrlEncode: [String: String]) -> HttpMethod {
      let bodyString = dictToWwwUrlEncode
         .map { "\($0.key)=\($0.value.urlEncoded)" }
         .joined(separator: "&")
      return .post(body: bodyString.data(using: .utf8)!)
   }
   
   public func patch(dictToWwwUrlEncode: [String: String]) -> HttpMethod {
      let bodyString = dictToWwwUrlEncode
         .map { "\($0.key)=\($0.value.urlEncoded)" }
         .joined(separator: "&")
      return .patch(body: bodyString.data(using: .utf8)!)
   }
}
