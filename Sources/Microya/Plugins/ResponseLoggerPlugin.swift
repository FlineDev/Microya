import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Allows to log responses the given way provided by a closure after the response has been received,
/// but before the completion block is called.
public class ResponseLoggerPlugin<JsonApiType: JsonApi>: Plugin<JsonApiType> {
    private let logClosure: (JsonApiType.URLSessionResult) -> Void

    public init(logClosure: @escaping (JsonApiType.URLSessionResult) -> Void) {
        self.logClosure = logClosure
    }

    override public func didPerformRequest<ResultType: Decodable>(
        urlSessionResult: JsonApiType.URLSessionResult,
        typedResult: JsonApiType.TypedResult<ResultType>,
        endpoint: JsonApiType
    ) {
        logClosure(urlSessionResult)
    }
}
