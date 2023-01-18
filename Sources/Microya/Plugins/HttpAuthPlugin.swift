import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Provides support for the HTTP "Authorization" header based on the "Basic" or "Bearer" schemes.
/// See also: https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication
public class HttpAuthPlugin<EndpointType: Endpoint>: Plugin<EndpointType> {
   /// The authentication scheme.
   public enum Scheme: String {
      /// The "Basic" authentication scheme. See also: https://datatracker.ietf.org/doc/html/rfc7617
      case basic = "Basic"
      
      /// The "Bearer" authentication scheme. See also: https://datatracker.ietf.org/doc/html/rfc6750
      case bearer = "Bearer"
   }
   
   private let scheme: Scheme
   private let tokenClosure: () -> String?
   
   /// - Parameters:
   ///   - scheme: The authentication scheme to use for the token.
   ///   - tokenClosure: The closure which returns the access token in case one is available.
   public init(
      scheme: Scheme,
      tokenClosure: @escaping () -> String?
   ) {
      self.scheme = scheme
      self.tokenClosure = tokenClosure
   }
   
   override public func modifyRequest(_ request: inout URLRequest, endpoint: EndpointType) {
      // prefer any 'Authorization' header set by a specific endpoint over the plugin
      guard request.value(forHTTPHeaderField: "Authorization") == nil else { return }

      if let token = tokenClosure() {
         request.addValue("\(scheme.rawValue) \(token)", forHTTPHeaderField: "Authorization")
      }
   }
}
