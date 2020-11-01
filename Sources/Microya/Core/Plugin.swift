import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A Plugin receives callbacks to perform side effects wherever a request is sent or received.
///
/// for example, a plugin may be used to
///     - log network requests
///     - hide and show a network activity indicator
///     - inject additional information into a request (like for authentication)
open class Plugin<EndpointType: Endpoint> {
    /// Initializes a new plugin object.
    public init() {}

    /// Called to modify a request before sending.
    open func modifyRequest(_ request: URLRequest, endpoint: EndpointType) -> URLRequest { request }

    /// Called immediately before a request is sent.
    open func willPerformRequest(_ request: URLRequest, endpoint: EndpointType) { /* no-op */ }

    /// Called after a response has been received & decoded, but before calling the completion handler.
    open func didPerformRequest<ResultType: Decodable>(
        urlSessionResult: ApiProvider<EndpointType>.URLSessionResult,
        typedResult: ApiProvider<EndpointType>.TypedResult<ResultType>,
        endpoint: EndpointType
    ) { /* no-op */ }
}
