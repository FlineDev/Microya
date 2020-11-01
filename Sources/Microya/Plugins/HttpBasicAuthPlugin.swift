import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Provides support for the HTTP "Authorization" header based on the "Basic" scheme.
/// See also: https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication
public class HttpBasicAuthPlugin<EndpointType: Endpoint>: Plugin<EndpointType> {
    private let tokenClosure: () -> String?

    public init(tokenClosure: @escaping () -> String?) {
        self.tokenClosure = tokenClosure
    }

    override public func modifyRequest(_ request: inout URLRequest, endpoint: EndpointType) {
        if let token = tokenClosure() {
            request.addValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}
