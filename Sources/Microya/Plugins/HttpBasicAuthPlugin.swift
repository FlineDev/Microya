import Foundation

/// Provides support for the HTTP "Authorization" header based on the "Basic" scheme.
/// See also: https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication
public class HttpBasicAuthPlugin<JsonApiType: JsonApi>: Plugin<JsonApiType> {
    private let tokenClosure: () -> String?

    public init(tokenClosure: @escaping () -> String?) {
        self.tokenClosure = tokenClosure
    }

    override public func modifyRequest(_ request: URLRequest, endpoint: JsonApiType) -> URLRequest {
        var request = request

        if let token = tokenClosure() {
            request.addValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
