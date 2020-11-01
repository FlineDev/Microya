import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Allows to log responses the given way provided by a closure after the response has been received,
/// but before the completion block is called.
public class ResponseLoggerPlugin<EndpointType: Endpoint>: Plugin<EndpointType> {
    private let logClosure: (ApiProvider<EndpointType>.URLSessionResult) -> Void

    public init(logClosure: @escaping (ApiProvider<EndpointType>.URLSessionResult) -> Void) {
        self.logClosure = logClosure
    }

    override public func didPerformRequest<ResultType: Decodable>(
        urlSessionResult: ApiProvider<EndpointType>.URLSessionResult,
        typedResult: ApiProvider<EndpointType>.TypedResult<ResultType>,
        endpoint: EndpointType
    ) {
        logClosure(urlSessionResult)
    }
}
